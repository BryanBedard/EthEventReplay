// Dependencies
var Connection = require('tedious').Connection;
var Request = require('tedious').Request;
var TYPES = require('tedious').TYPES;
var async = require('async');
var Subscriber = require("./Subscriber");
var Contract = require("./Contract");
var Event = require("./Event");

// Exports
module.exports = {
    param : function (value) {
        if (value)
            return "'" + value + "'";
        else
            return "NULL";  
    },

    getSubscriber: function (connection, subscriberName, callback) {            
        if (!subscriberName)
            throw 'subscriberName missing.';

        // We only expect one Subscriber to be returned. If multiple rows come back, the properties of result will be overwritten and only the last one will be returned.
        var result = new Subscriber();
        var sql = 'EXEC Subscriber_GetList @SubscriberName = ' + this.param(subscriberName) + ';';

        request = new Request(
            sql,
            function(err, rowCount, rows) {
            if (err) {
                callback(err);
            } else {
                console.log(rowCount + ' row(s) returned');
                callback(null, result);
            }
        });
    
        request.on('row', function(columns) {
            result.SubscriberId = columns[0].value;
            result.SubscriberName = columns[1].value;
            result.IsActive = columns[2].value;
            result.CreatedBy = columns[3].value;
            result.CreatedDate = columns[4].value;
            result.UpdatedBy = columns[5].value;
            result.UpdatedDate = columns[6].value;
        });
    
        // Execute SQL statement
        connection.execSql(request);                    
    },

    createSubscriber: function (connection, subscriberName, callback) {
        if (!subscriberName)
            throw 'subscriberName missing.';

        var result = new Subscriber();
        var sql = 'EXEC Subscriber_Save ' +
            '@SubscriberId = NULL, ' +
            '@SubscriberName = ' + this.param(subscriberName) + ', ' +
            '@IsActive = 1,' + 
            '@CreatedBy = 0,' +
            '@UpdatedBy = 0;';

        request = new Request(
            sql,
            function(err, rowCount, rows) {
            if (err) {
                callback(err);
            } else {
                console.log(rowCount + ' row(s) returned');
                callback(null, result);
            }
        });
    
        request.on('row', function(columns) {
            result.SubscriberId = columns[0].value;
            result.SubscriberName = columns[1].value;
            result.IsActive = columns[2].value;
            result.CreatedBy = columns[3].value;
            result.CreatedDate = columns[4].value;
            result.UpdatedBy = columns[5].value;
            result.UpdatedDate = columns[6].value;
        });
    
        // Execute SQL statement
        connection.execSql(request);
    },

    getContracts: function (connection, contractAddress, callback) {            
        var result = [];
        var sql = 'EXEC Contract_GetList';
        var separator = '';
        
        if (contractAddress) {
            sql += separator + ' @ContractAddress = ' + this.param(contractAddress);
            separator = ",";
        }

        sql += ';';

        request = new Request(
            sql,
            function(err, rowCount, rows) {
            if (err) {
                callback(err);
            } else {
                console.log(rowCount + ' row(s) returned');
                callback(null, result);
            }
        });
    
        request.on('row', function(columns) {
            var contract = new Contract();
            contract.ContractId = columns[0].value;
            contract.ContractName = columns[1].value;
            contract.ContractAddress = columns[2].value;
            contract.ContractABI = columns[3].value;
            contract.IsActive = columns[4].value;
            contract.CreatedBy = columns[5].value;
            contract.CreatedDate = columns[6].value;
            contract.UpdatedBy = columns[7].value;
            contract.UpdatedDate = columns[8].value;

            result.push(contract);
        });
    
        // Execute SQL statement
        connection.execSql(request);                    
    },
    
    getEvents: function (connection, contractAddress, eventName, callback) {            
        var result = [];
        var sql = 'EXEC Event_GetList';
        var separator = '';
        
        if (contractAddress) {
            sql += separator + ' @ContractAddress = ' + this.param(contractAddress);
            separator = ",";
        }

        if (eventName) {
            sql += separator + ' @EventName = ' + this.param(eventName);
            separator = ",";
        }

        sql += ';';
        
        request = new Request(
            sql,
            function(err, rowCount, rows) {
            if (err) {
                callback(err);
            } else {
                console.log(rowCount + ' row(s) returned');
                callback(null, result);
            }
        });
    
        request.on('row', function(columns) {
            var event = new Event();
            event.EventId = columns[0].value;
            event.ContractId = columns[1].value;
            event.EventName = columns[3].value;
            event.IsActive = columns[4].value;
            event.CreatedBy = columns[5].value;
            event.CreatedDate = columns[6].value;
            event.UpdatedBy = columns[7].value;
            event.UpdatedDate = columns[8].value;

            result.push(event);
        });
    
        // Execute SQL statement
        connection.execSql(request);                    
    }    
}