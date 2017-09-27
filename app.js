// Dependencies
var Web3 = require('web3');
var EventLogReader = require('./EventLogReader');
var Connection = require('tedious').Connection;
var Request = require('tedious').Request;
var TYPES = require('tedious').TYPES;
var async = require('async');
var Repository = require("./Repository");
var BigNumber = require("big-number");

// Parameters
var params = new Object();
params.subscriberName = "titlesource.com";
params.contractAddress = null;
params.eventName = null;

// App Globals
var app = new Object();
app.web3 = null;
app.connection = null;
app.subscriber = null;
app.contracts = null;
app.events = null;
app.latestBlockNumber = null;


// Functions
function run() {
    if (typeof web3 !== 'undefined') {
        web3 = new Web3(web3.currentProvider);
    }
    else {
        // The next two should work but throw an exception that send cannot be called while not connected
        //var web3 = new Web3("ws://localhost:8546");
        //var web3 = new Web3("http://localhost:8546");
        web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
    }

    var versionw3 = web3.version;
    console.log(versionw3 + " web3 version loaded");

    // TODO: Read connection settings from a file
    // Create connection to database
    var config = {
        userName: '', // update me
        password: '', // update me
        server: 'rethink-pchain-dev-ue-sql.database.windows.net',
        options: {
            database: 'EventReplay',
            encrypt: 'true'
        }
    }
    
    app.connection = new Connection(config);

    // Attempt to connect and execute queries if connection goes through
    app.connection.on(
        'connect', 
        (err) => {
            if (err) {
                console.log(err);
            }
            else {
                console.log('Connected');    

                async.waterfall(
                    [readSubscriber,
                    verifySubscriber],
                    readSubscriberCompleted
                );
            }
        }
    );    
}

function readSubscriber(callback) {
    console.log("readSubscriber");
    Repository.getSubscriber(app.connection, params.subscriberName, callback);
}

function verifySubscriber(subscriber, callback) {
    console.log("verifySubscriber");

    if (!subscriber.SubscriberId) {
        Repository.createSubscriber(app.connection, params.subscriberName, callback);
    }
    else {
        callback(null, subscriber);
    }
}

function readSubscriberCompleted(err, subscriber)
{
    console.log('readSubscriberCompleted');    

    if (err) {
        console.log(err)
    }
    else {
        app.subscriber = subscriber;

        async.series(
            [getLatestBlockNumber,
            readContracts,
            readEvents],
            readContractsAndEventsCompleted
        );
    }
}

function getLatestBlockNumber(callback) {
    web3.eth.getBlockNumber((err, latestBlockNumber) => {
        if (err) {
            callback(err);
        }
        else {
            callback(null, latestBlockNumber);
        }        
    });
}

function readContracts(callback) {
    console.log('readContracts');
    Repository.getContracts(app.connection, params.contractAddress, callback);
}

function readEvents(callback) {
    console.log('readEvents');        
    Repository.getEvents(app.connection, params.contractAddress, params.eventName, callback);
}

function readContractsAndEventsCompleted(err, results)
{
    console.log('readContractsAndEventsCompleted');
    if (err) {
        console.log(err)
    }
    else {
        app.latestBlockNumber = results[0];        
        app.contracts = results[1];
        app.events = results[2];
    }
    
    readEventLogs();
}

function readEventLogs() {
    async.eachSeries(
        app.events,
        readEventLog,
        readEventLogsCompleted
    );
}

function readEventLog(event, callback) {
    async.waterfall(
        [(callback2) => readSubscription(event, callback2),
        verifySubscription],
        (err, subscription) => {
            if (err) {
                console.log(err);
            }
            else {                
                startReadingLogs(subscription, callback)
            }
        }
    )
}

function readEventLogsCompleted(err) {
    if (err) {
        console.log(err);
    }
    
    app.connection.close();    
}


function readSubscription(event, callback) {
    console.log("readSubscription");
    Repository.getSubscription(app.connection, app.subscriber.SubscriberId, event.EventId, callback);
}

function verifySubscription(subscription, callback) {
    console.log("verifySubscription");
    if (!subscription.SubscriptionId) {
        Repository.createSubscription(app.connection, subscription.SubscriberId, subscription.EventId, callback);
    }
    else
    {
        callback(null, subscription);
    }
}

function startReadingLogs(subscription, callback)
{
    console.log('startReadingLogs');    

    // Read the event log (need the contract oject and the event object)
    var logs = [];
    event = getEvent(subscription.EventId);
    contract = getContract(event.ContractId);
    
    readMoreLogs(logs, subscription, contract, event, callback);
}

function readMoreLogs(logs, subscription, contract, event, callback) {
    var fromBlock = BigNumber.n(subscription.LastBlockRead.toString()).add(1);
    var toBlock = BigNumber.n(subscription.LastBlockRead.toString()).add(100);
    if (toBlock.gte(app.latestBlockNumber)) {
        toBlock = BigNumber.n(app.latestBlockNumber);
    }
    
    EventLogReader.read(
        web3,
        eval(contract.ContractABI),
        contract.ContractAddress,
        event.EventName,
        fromBlock,
        toBlock,
        (err, eventLogs) => {
            if (err) {
                callback(err);
            }
            else {
                for (var i = 0; i < eventLogs.length; i++) {
                    logs.push(eventLogs[i]);
                }

                subscription.LastBlockRead = BigNumber.n(toBlock.toString());
                
                if (subscription.LastBlockRead.gte(app.latestBlockNumber)) {
                    callback(null, logs);
                }
                else {
                    readMoreLogs(logs, subscription, contract, event, callback);
                }                    
            }
        }
    );
}

function getEvent(eventId) {
    var result = null;
    for (var i = 0; i < app.events.length; i++) {
        event = app.events[i];
        if (event.EventId === eventId) {
            result = event;
            break;
        }
    }

    return result;
}

function getContract(contractId) {
    var result = null;
    for (var i = 0; i < app.contracts.length; i++) {
        contract = app.contracts[i];
        if (contract.ContractId === contractId) {
            result = contract;
            break;
        }
    }

    return result;
}


// Program
// TODO: Pass in parameters for SubscriberName, ContractAddress, EventName and ReadFromBlock:
//      SubscriberName. If the passed subscriber does not exist, it will be inserted automatically into the database.
//      If ContractAddress is null, process all active contracts, otherwise process just that contract
//      If EventName is null, process all active events, otherwise process just that event
//      If ReadFromBlock is null, will read from the last block read for this subscriber. If a ReadFromBlock is specified
//      will override the LastBlockRead and read from the specified block instead.
// When locking, locks at the Subscription level. If a subscription does not exist for the subscriber/contract/event being processed a new subscription will automatically be created.
run();
