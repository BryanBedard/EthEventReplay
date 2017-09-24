// Dependencies
var Web3 = require('web3');
var EventLog = require('./EventLog');
var Connection = require('tedious').Connection;
var Request = require('tedious').Request;
var TYPES = require('tedious').TYPES;
var async = require('async');
var Repository = require("./Repository");

// Module globals
var web3;
var connection;
var subscriberName = "titlesource.com";
var contractAddress = null;
var eventName = null;

var subscriber;
var contracts;
var events;

// Functions
function init() {
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

    // Read the configuration from SQL Server
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
    
    connection = new Connection(config);

    // Attempt to connect and execute queries if connection goes through
    connection.on('connect', function(err) {
        if (err) {
            console.log(err);
        } else {
            console.log('Connected');    
        }

        async.waterfall(
            [readSubscriber,
            verifySubscriber],
            getSubscriberCompleted
        )
    });    
}

function readSubscriber(callback) {
    console.log("readSubscriber");
    Repository.getSubscriber(connection, subscriberName, callback);
    // Repository.getSubscriber calls the callback, don't need to do it here.
}

function verifySubscriber(subscriber, callback) {
    console.log("verifySubscriber");
    if (!subscriber.SubscriberId) {
        Repository.createSubscriber(connection, subscriberName, callback);
        // Repository.createSubscriber calls the callback, don't need to do it here.
    }
    else
    {
        callback(null, subscriber);
    }
}

function getSubscriberCompleted(err, result)
{
    console.log('getSubscriberCompleted');    
    if (err) {
        console.log(err)
    }
    else {
        subscriber = result;
        async.series(
            [readContracts,
            readEvents],
            getContractsAndEventsCompleted
        )
    }
}

function readContracts(callback) {
    console.log('readContracts');
    Repository.getContracts(connection, contractAddress, callback);
    // Repository.getContracts calls the callback, don't need to do it here.    
}

function readEvents(callback) {
    console.log('readEvents');
    Repository.getEvents(connection, contractAddress, eventName, callback);
    // Repository.getEvents calls the callback, don't need to do it here.    
}

function getContractsAndEventsCompleted(err, results)
{
    console.log('getContractsAndEventsCompleted');
    if (err) {
        console.log(err)
    }
    else {
        contracts = results[0];
        events = results[1];
    }
    connection.close();
}


// Program
// TODO: Pass in parameters for SubscriberName, ContractAddress, EventName and ReadFromBlock:
//      SubscriberName. If the passed subscriber does not exist, it will be inserted automatically into the database.
//      If ContractAddress is null, process all active contracts, otherwise process just that contract
//      If EventName is null, process all active events, otherwise process just that event
//      If ReadFromBlock is null, will read from the last block read for this subscriber. If a ReadFromBlock is specified
//      will override the LastBlockRead and read from the specified block instead.
// When locking, locks at the Subscription level. If a subscription does not exist for the subscriber/contract/event being processed a new subscription will automatically be created.
init();

/* Temporarily commented out while learning how to work with SQL Server 
EventLog.readEventLog(
    web3,
    [{ "constant": false, "inputs": [{ "name": "val", "type": "int256" }], "name": "multiply", "outputs": [{ "name": "result", "type": "int256" }], "payable": false, "type": "function" }, { "inputs": [{ "name": "multiplier", "type": "int256" }], "payable": false, "type": "constructor" }, { "anonymous": false, "inputs": [{ "indexed": true, "name": "sender", "type": "address" }, { "indexed": false, "name": "multiplier", "type": "int256" }, { "indexed": false, "name": "val", "type": "int256" }, { "indexed": false, "name": "result", "type": "int256" }], "name": "Multiplied", "type": "event" }], // ABI
    '0x243E72B69141f6af525a9A5FD939668EE9F2b354', // Contract Address
    'Multiplied', // Event Name
    0, // From Block
    'latest' // To Block
);*/

