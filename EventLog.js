module.exports = {
    readEventLog : function (web3, abi, contractAddress, eventName, fromBlock, toBlock) {
        var contract = new web3.eth.Contract(abi, contractAddress);

        contract.getPastEvents(eventName,
            { fromBlock: fromBlock, toBlock: toBlock },
        
            function (error, logs) {
                if (error) {
                    console.log(error);
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

                            var s = "Event:\n";
                            s += "  Date: " + eventDate + "\n";
                            s += "  Address: " + log.address + "\n";
                            s += "  Return Values: \n";

                            for (var property in log.returnValues) {
                                // Check hasOwnProperty to avoid additional properties that are part of the prototype
                                // https://stackoverflow.com/questions/8312459/iterate-through-object-properties
                                if (log.returnValues.hasOwnProperty(property))
                                {
                                    // Ethereum (or Web3) seems to add two copies of the return values to the
                                    // object. One set has properties with the same name as the event parameers
                                    // and the other set has properties in the same order named 0, 1, 2...
                                    // Filter out the properties with fully numeric names.
                                    if (isNaN(property))
                                        s += "    " + property + ": " + log.returnValues[property] + "\n";
                                }
                            }

                            s += "  Blockhash: " + log.blockHash + "\n";
                            s += "  Block Number: " + log.blockNumber + "\n";
                            s += "  Log Index: " + log.logIndex + "\n";
                            s += "  Event: " + log.event + "\n";
                            s += "  Removed: " + log.removed + "\n";
                            s += "  Transaction Index: " + log.transactionIndex + "\n";
                            s += "  Transaction Hash: " + log.transactionHash + "\n";
                            s += "  ID: " + log.id + "\n";
                            s += "  Signature: " + log.signature + "\n";
                            s += "\n";

                            console.log(s);                    
                        });
                    }
                }
            });
        }
}