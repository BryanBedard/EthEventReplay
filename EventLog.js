module.exports = {
    readEventLogs : function (web3, abi, contractAddress, eventName, fromBlock, toBlock, callback) {
        var result = [];
        var contract = new web3.eth.Contract(abi, contractAddress);

        contract.getPastEvents(eventName,
            { fromBlock: fromBlock, toBlock: toBlock },
        
            function (error, logs) {
                if (error) {
                    console.log(error);
                    callback(error);
                }
                else {
                    for (var i = 0; i < logs.length; i++) {
                        var log = logs[i];

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

                            // TODO: Problem, EventLog is not defined for some reason.
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
                            eventLog.blockNumbr = log.blockNumber;
                            eventLog.logIndex = log.logIndex;
                            eventLog.event = log.event;
                            eventLog.removed = log.removed;
                            eventLog.transactionIndex = log.transactionIndex;
                            eventLog.transactionHash = log.transactionHash;
                            eventLog.id = log.id;
                            eventLog.signature = log.signature;

                            result.push(eventLog);
                        });
                    }

                    // TODO: Problem, Promise.all doesn't block so we reach tis line too soon.
                    // Need to defer this until after all of the logs have been processed.
                    callback(null, result);
                }
            }
        );
    },

    EventLog : function() {
        this.eventDate = null;
        this.address = null;
        this.returnValues = new Object();
        this.blockHash = null;
        this.blockNumber = null;
        this.logIndex = null;
        this.event = null;
        this.removed = null;
        this.transactionIndex = null;
        this.transactionHash = null;
        this.id = null;
        this.signature = null;

        this.toString = function() {
            var s = "Event:\n";
            s += "  Date: " + eventDate + "\n";
            s += "  Address: " + address + "\n";
            s += "  Return Values: \n";

            for (var property in returnValues) {
                // Check hasOwnProperty to avoid additional properties that are part of the prototype
                // https://stackoverflow.com/questions/8312459/iterate-through-object-properties
                if (returnValues.hasOwnProperty(property))
                {
                    s += "    " + property + ": " + returnValues[property] + "\n";
                }
            }

            s += "  BlockHash: " + blockHash + "\n";
            s += "  Block Number: " + blockNumber + "\n";
            s += "  Log Index: " + logIndex + "\n";
            s += "  Event: " + eventName + "\n";
            s += "  Removed: " + removed + "\n";
            s += "  Transaction Index: " + transactionIndex + "\n";
            s += "  Transaction Hash: " + transactionHash + "\n";
            s += "  ID: " + id + "\n";
            s += "  Signature: " + signature + "\n";
            s += "\n";

            return s;
        }
    }
}