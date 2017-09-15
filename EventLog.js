// Program
var Web3 = require('web3');
var web3;

init();

readEventLog(
    [{ "constant": false, "inputs": [{ "name": "val", "type": "int256" }], "name": "multiply", "outputs": [{ "name": "result", "type": "int256" }], "payable": false, "type": "function" }, { "inputs": [{ "name": "multiplier", "type": "int256" }], "payable": false, "type": "constructor" }, { "anonymous": false, "inputs": [{ "indexed": true, "name": "sender", "type": "address" }, { "indexed": false, "name": "multiplier", "type": "int256" }, { "indexed": false, "name": "val", "type": "int256" }, { "indexed": false, "name": "result", "type": "int256" }], "name": "Multiplied", "type": "event" }], // ABI
    '0x243E72B69141f6af525a9A5FD939668EE9F2b354', // Contract Address
    'Multiplied', // Event Name
    0, // From Block
    'latest' // To Block
);


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
}

function readEventLog(abi, contractAddress, eventName, fromBlock, toBlock) {
    var contract = new web3.eth.Contract(abi, contractAddress);

    contract.getPastEvents(eventName,
        { fromBlock: fromBlock, toBlock: toBlock },
    
        function (error, logs) {            
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
        });
}