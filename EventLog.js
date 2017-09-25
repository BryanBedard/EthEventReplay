module.exports =  function() {
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