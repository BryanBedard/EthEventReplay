var EventLog = require("./EventLog");
var async = require("async");

module.exports = {
    read : function (web3, abi, contractAddress, eventName, fromBlock, toBlock, callback) {
        var result = [];
        var contract = new web3.eth.Contract(abi, contractAddress);

        contract.getPastEvents(eventName,
            { fromBlock: fromBlock.val(), toBlock: toBlock.val() },
        
            function (error, logs) {
                if (error) {
                    console.log(error);
                    callback(error);
                }
                else {
                    async.eachSeries(
                        logs,
                        (log, callback2) => {
                            // Promise.all waits for all of the promises in the array to complete then gives you an
                            // array with each of the promise results. You can pass a non-promise in the array and
                            // it just returns the value verbatim.
                            // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all
                            Promise.all(
                                [log,
                                web3.eth.getBlock(log.blockNumber)])
                            .then(values => {
                                var log = values[0];
                                var block = values[1];
                                var eventDate = new Date(block.timestamp * 1000);   // Convert from seconds to milliseconds

                                var eventLog = new EventLog();
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

                                result.push(eventLog);

                                callback2(null);
                            });
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
                }
            }
        );
    }
}