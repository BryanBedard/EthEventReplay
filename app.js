// Dependencies
var Web3 = require('web3');
var EventLog = require('./EventLog');
var Connection = require('tedious').Connection;
var Request = require('tedious').Request;
var TYPES = require('tedious').TYPES;
var async = require('async');

// Module globals
var web3;
var connection;

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
    
        async.waterfall(
            [start,
            readContracts],
            complete);
        }
    });    
}


function start(callback) {
    console.log("start");
    callback(null);
}

function readContracts(callback) {
    console.log('readContracts');

    
    // Read all rows from table
    request = new Request(
    'SELECT ContractId, ContractName, ContractAddress, ContractABI FROM Contract;',
    function(err, rowCount, rows) {
    if (err) {
        callback(err);
    } else {
        console.log(rowCount + ' row(s) returned');
        callback(null);
    }
    });

    // Print the rows read
    var result = "";
    request.on('row', function(columns) {
        columns.forEach(function(column) {
            if (column.value === null) {
                console.log('NULL');
            } else {
                result += column.value + " ";
            }
        });
        console.log(result);
        result = "";
    });

    // Execute SQL statement
    connection.execSql(request);
}

function complete(err, result) {
    if (err) {
        console.log(err);
    } else {
        console.log("complete");
    }

    connection.close();
}


// Program
// TODO: Pass in parameters for SubscriberName, ContractAddress, EventName and ReadFromBlock:
//      If Subscribername is null, process all known active subscribers. If the passed subscriber does not exist, it will be inserted automatically into the database.
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

