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
        s += "  Date: " + this.eventDate + "\n";
        s += "  Address: " + this.address + "\n";
        s += "  Return Values: \n";

        for (var property in this.returnValues) {
            // Check hasOwnProperty to avoid additional properties that are part of the prototype
            // https://stackoverflow.com/questions/8312459/iterate-through-object-properties
            if (this.returnValues.hasOwnProperty(property))
            {
                s += "    " + property + ": " + this.returnValues[property] + "\n";
            }
        }

        s += "  BlockHash: " + this.blockHash + "\n";
        s += "  Block Number: " + this.blockNumber + "\n";
        s += "  Log Index: " + this.logIndex + "\n";
        s += "  Event: " + this.eventName + "\n";
        s += "  Removed: " + this.removed + "\n";
        s += "  Transaction Index: " + this.transactionIndex + "\n";
        s += "  Transaction Hash: " + this.transactionHash + "\n";
        s += "  ID: " + this.id + "\n";
        s += "  Signature: " + this.signature + "\n";
        s += "\n";

        return s;
    }
}