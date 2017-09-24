// Dependencies
var Connection = require('tedious').Connection;
var Request = require('tedious').Request;
var TYPES = require('tedious').TYPES;
var async = require('async');
var Subscriber = require("./Subscriber");
var Contract = require("./Contract");
var Event = require("./Event");
var Subscription = require("./Subscription");

// Exports
module.exports = {
    stringParam : function (value) {
        if (value)
            return "'" + value + "'";
        else
            return "NULL";  
    },

    numParam : function (value) {
        if (value)
            return value;
        else
            return "NULL";  
    },
    
    getSubscriber: function (connection, subscriberName, callback) {            
        if (!subscriberName) {
            throw 'subscriberName missing.';
        }

        // We only expect one Subscriber to be returned. If multiple rows come back, the properties of result will be overwritten and only the last one will be returned.
        var result = new Subscriber();
        result.SubscriberName = subscriberName;     // In case the query fails, might be useful upon async return

        var sql = 'EXEC Subscriber_GetList @SubscriberName = ' + this.stringParam(subscriberName) + ';';

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
        if (!subscriberName) {
            throw 'subscriberName missing.';
        }

        var result = new Subscriber();
        var sql = 'EXEC Subscriber_Save ' +
            '@SubscriberId = NULL, ' +
            '@SubscriberName = ' + this.stringParam(subscriberName) + ', ' +
            '@IsActive = 1, ' + 
            '@CreatedBy = 0, ' +
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
            sql += separator + ' @ContractAddress = ' + this.stringParam(contractAddress);
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
            sql += separator + ' @ContractAddress = ' + this.stringParam(contractAddress);
            separator = ",";
        }

        if (eventName) {
            sql += separator + ' @EventName = ' + this.stringParam(eventName);
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
    },

    getSubscription: function (connection, subscriberId, eventId, callback) {            
        if (!subscriberId) {
            throw 'subscriberId missing.';
        }

        if (!eventId) {
            throw 'eventId missing.';
        }

        // We only expect one Subscription to be returned. If multiple rows come back, the properties of result will be overwritten and only the last one will be returned.
        var result = new Subscription();
        result.SubscriberId = subscriberId;     // In case the query fails, might be useful upon async return
        result.EventId = eventId;

        var sql = 'EXEC Subscription_GetList' +
            ' @SubscriberId = ' + this.numParam(subscriberId) + ',' + 
            ' @EventId = ' + this.numParam(eventId) + ';';

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
            result.SubscriptionId = columns[0].value;
            result.SubscriberId = columns[1].value;
            result.EventId = columns[5].value;
            result.LastBlockRead = columns[7].value;
            result.IsActive = columns[8].value;
            result.CreatedBy = columns[9].value;
            result.CreatedDate = columns[10].value;
            result.UpdatedBy = columns[11].value;
            result.UpdatedDate = columns[12].value;
        });
    
        // Execute SQL statement
        connection.execSql(request);                    
    },

    createSubscription: function (connection, subscriberId, eventId, callback) {
        if (!subscriberId) {
            throw 'subscriberId missing.';
        }

        if (!eventId) {
            throw 'eventId missing.';
        }

        var result = new Subscription();
        var sql = 'EXEC Subscription_Save ' +
            '@SubscriptionId = NULL, ' +
            '@SubscriberId = ' + this.numParam(subscriberId) + ', ' +
            '@EventId = ' + this.numParam(eventId) + ', ' +
            '@LastBlockRead = 0, ' +
            '@IsActive = 1, ' + 
            '@CreatedBy = 0, ' +
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
            result.SubscriptionId = columns[0].value;
            result.SubscriberId = columns[1].value;
            result.EventId = columns[2].value;
            result.LastBlockRead = columns[3].value;
            result.IsActive = columns[4].value;
            result.CreatedBy = columns[5].value;
            result.CreatedDate = columns[6].value;
            result.UpdatedBy = columns[7].value;
            result.UpdatedDate = columns[8].value;
        });
    
        // Execute SQL statement
        connection.execSql(request);
    }
}