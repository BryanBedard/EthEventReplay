// Dependencies
var Web3 = require('web3');
var EventLogReader = require('./EventLogReader');
var Connection = require('tedious').Connection;
var Request = require('tedious').Request;
var TYPES = require('tedious').TYPES;
var async = require('async');
var Repository = require("./Repository");
var BigNumber = require("big-number");


function App() {
    // Members
    this.subscriberName = null;
    this.contractAddress = null;
    this.eventName = null;    
    this.web3 = null;
    this.connection = null;
    this.subscriber = null;
    this.contracts = null;
    this.events = null;
    this.latestBlockNumber = null;
    this.eventLogCallback = null;
}

// Functions
App.prototype.run = function(subscriberName, contractAddress, eventName, callback) {
    console.log('run');

    var app = this; // For use inside closures to preserve this
    this.subscriberName = subscriberName;
    this.contractAddress = contractAddress;
    this.eventName = eventName;
    this.eventLogCallback = callback;

    if (typeof web3 !== 'undefined') {
        this.web3 = new Web3(web3.currentProvider);
    }
    else {
        // The next two should work but throw an exception that send cannot be called while not connected
        //var web3 = new Web3("ws://localhost:8546");
        //var web3 = new Web3("http://localhost:8546");
        this.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
    }

    var versionw3 = this.web3.version;
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
    
    this.connection = new Connection(config);

    // Attempt to connect and execute queries if connection goes through
    this.connection.on(
        'connect', 
        (err) => {
            if (err) {
                console.log(err);
            }
            else {
                console.log('Connected');    

                // Since async will call the functions below, async will be "this" when the 
                // functions execute so we need to bind() them to app (which is this for
                // outer object).
                async.waterfall(
                    [app.readSubscriber.bind(app),
                    app.verifySubscriber.bind(app)],
                    app.readSubscriberCompleted.bind(app)
                );
            }
        }
    );    
}

App.prototype.readSubscriber = function(callback) {
    console.log('readSubscriber');
    Repository.getSubscriber(this.connection, this.subscriberName, callback);
}

App.prototype.verifySubscriber = function(subscriber, callback) {
    console.log('verifySubscriber');

    if (!subscriber.SubscriberId) {
        Repository.createSubscriber(this.connection, this.subscriberName, callback);
    }
    else {
        callback(null, subscriber);
    }
}

App.prototype.readSubscriberCompleted = function(err, subscriber)
{
    console.log('readSubscriberCompleted');    

    if (err) {
        console.log(err)
    }
    else {
        this.subscriber = subscriber;

        async.series(
            [this.getLatestBlockNumber.bind(this),
            this.readContracts.bind(this),
            this.readEvents.bind(this)],
            this.readContractsAndEventsCompleted.bind(this)
        );
    }
}

App.prototype.getLatestBlockNumber = function(callback) {
    console.log('getLatestBlockNumber');

    this.web3.eth.getBlockNumber((err, latestBlockNumber) => {
        if (err) {
            callback(err);
        }
        else {
            callback(null, latestBlockNumber);
        }        
    });
}

App.prototype.readContracts = function(callback) {
    console.log('readContracts');
    Repository.getContracts(this.connection, this.contractAddress, callback);
}

App.prototype.readEvents = function(callback) {
    console.log('readEvents');        
    Repository.getEvents(this.connection, this.contractAddress, this.eventName, callback);
}

App.prototype.readContractsAndEventsCompleted = function(err, results)
{
    console.log('readContractsAndEventsCompleted');

    if (err) {
        console.log(err)
    }
    else {
        this.latestBlockNumber = results[0];        
        this.contracts = results[1];
        this.events = results[2];

        console.log('Latest Block Number: ' + this.latestBlockNumber);
    }
    
    this.readEventLogs();
}

App.prototype.readEventLogs = function() {
    console.log('readEventLogs');

    async.eachSeries(
        this.events,
        this.readEventLog.bind(this),
        this.readEventLogsCompleted.bind(this)
    );
}

App.prototype.readEventLog = function(event, callback) {
    var app = this; // For use inside closures to preserve this
    console.log('readEventLog');

    async.waterfall(
        [(callback2) => this.readSubscription(event, callback2),
        this.verifySubscription.bind(this)],
        (err, subscription) => {
            if (err) {
                console.log(err);
            }
            else {                
                app.startReadingLogs(subscription, callback)
            }
        }
    )
}

App.prototype.readEventLogsCompleted = function(err) {
    console.log('readEventLogsCompleted');

    if (err) {
        console.log(err);
    }
    
    this.connection.close();    
}


App.prototype.readSubscription = function(event, callback) {
    console.log('readSubscription');
    Repository.getSubscription(this.connection, this.subscriber.SubscriberId, event.EventId, callback);
}

App.prototype.verifySubscription = function(subscription, callback) {
    console.log('verifySubscription');
    if (!subscription.SubscriptionId) {
        Repository.createSubscription(this.connection, subscription.SubscriberId, subscription.EventId, callback);
    }
    else
    {
        callback(null, subscription);
    }
}

App.prototype.startReadingLogs = function(subscription, callback)
{
    console.log('startReadingLogs');    

    // Read the event log (need the contract oject and the event object)
    var event = this.getEvent(subscription.EventId);
    var contract = this.getContract(event.ContractId);
    
    this.readMoreLogs(subscription, contract, event, callback);
}

App.prototype.readMoreLogs = function(subscription, contract, event, callback) {
    var app = this; // For use inside closures to preserve this
    console.log('readMoreLogs');

    var fromBlock = BigNumber.n(subscription.LastBlockRead.toString()).add(1);
    var toBlock = BigNumber.n(subscription.LastBlockRead.toString()).add(100);
    if (toBlock.gte(this.latestBlockNumber)) {
        toBlock = BigNumber.n(this.latestBlockNumber);
    }
    
    EventLogReader.read(
        this.web3,
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
                    if (this.eventLogCallback) {
                        this.eventLogCallback(
                            this.subscriber.SubscriberName,
                            contract.contracctAddress,
                            event.eventName,
                            eventLogs[i]
                        );
                    }
                }

                subscription.LastBlockRead = BigNumber.n(toBlock.toString());
                
                if (subscription.LastBlockRead.gte(this.latestBlockNumber)) {
                    callback(null);
                }
                else {
                    app.readMoreLogs(subscription, contract, event, callback);
                }                    
            }
        }
    );
}

App.prototype.getEvent = function(eventId) {
    var result = null;
    for (var i = 0; i < this.events.length; i++) {
        event = this.events[i];
        if (event.EventId === eventId) {
            result = event;
            break;
        }
    }

    return result;
}

App.prototype.getContract = function(contractId) {
    var result = null;
    for (var i = 0; i < this.contracts.length; i++) {
        contract = this.contracts[i];
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
var app = new App();
app.run(
    "titlesource.com",  // Subscriber Name
    null,               // Contract Address
    null,               // Event Name
    (subscriberName, contractAddress, eventName, eventLog) => {
        // Take whatever ation you want here in response to the event (e.g. write to a database)
        console.log(eventLog.toString());
    }    
);
