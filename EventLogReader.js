var EventLog = require("./EventLog");
var async = require("async");

module.exports = {
    read : function (web3, abi, contractAddress, eventName, fromBlock, toBlock, callback) {
        var contract = new web3.eth.Contract(abi, contractAddress);

        contract.getPastEvents(eventName,
            { fromBlock: fromBlock.val(), toBlock: toBlock.val() },
        
            (err, logs) => {
                if (err) {
                    callback(err);
                }
                else {
                    this.logsToEventLogs(logs, callback);
                }
            }
        );
    },

    logsToEventLogs: function (logs, callback) {
        var result = [];        
        async.eachSeries(
            logs,
            (log, callback2) => {
                web3.eth.getBlock(
                    log.blockNumber,
                    (err, block) => {
                        if (err) {
                            callback2(err);
                        }
                        else {
                            var eventLog = this.getEventLog(log, block);                                    
                            result.push(eventLog);
                            callback2(null);
                        }
                    }
                );
            },
            (err) => {
                if (err) {
                    callback(err);
                }
                else {
                    callback(null, result);                                
                }
            }
        );
    },

    getEventLog: function (log, block) {
        var eventLog = new EventLog();

        var eventDate = new Date(block.timestamp * 1000);   // Convert from seconds to milliseconds        
        eventLog.eventDate = eventDate;

        eventLog.address = log.address;

        for (var property in log.returnValues) {
            // Check hasOwnProperty to avoid additional properties that are part of the prototype
            // https://stackoverflow.com/questions/8312459/iterate-through-object-properties
            if (log.returnValues.hasOwnProperty(property))
            {
                // Ethereum (or Web3) seems to add two copies of the return values to the
                // object. One set has properties with the same name as the event parameers
                // and the other set has properties in the same order named 0, 1, 2...
                // Filter out the properties with fully numeric names.
                if (isNaN(property)) {
                    eventLog.returnValues[property] = log.returnValues[property];
                }
            }
        }

        eventLog.blockHash = log.blockHash;
        eventLog.blockNumber = log.blockNumber;
        eventLog.logIndex = log.logIndex;
        eventLog.event = log.event;
        eventLog.removed = log.removed;
        eventLog.transactionIndex = log.transactionIndex;
        eventLog.transactionHash = log.transactionHash;
        eventLog.id = log.id;
        eventLog.signature = log.signature;          
        
        return eventLog;
    }
}