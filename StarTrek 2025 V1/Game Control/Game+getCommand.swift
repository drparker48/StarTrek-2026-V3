extension Game {
    
    mutating func getCommand () {
        if debug {print("getCommand()")}
        displayBlankLine()
        messageEntries.append(MessageEntry(line: "SELECT COMMAND:"))
    }
    
}

