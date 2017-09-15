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
            var s = "";
            for (var i = 0; i < logs.length; i++) {
                var log = logs[i];
                s += "Event:\n";
                //s += "  Timestamp: " + block.timestamp + "\n";
                s += "  Address: " + log.address + "\n";
                s += "  Return Values: \n";
                s += "    Sender: " + log.returnValues.sender + "\n";
                s += "    Multiplier: " + log.returnValues.multiplier + "\n";
                s += "    Val: " + log.returnValues.val + "\n";
                s += "    Result: " + log.returnValues.result + "\n";
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
            }

            console.log(s);
        });
}