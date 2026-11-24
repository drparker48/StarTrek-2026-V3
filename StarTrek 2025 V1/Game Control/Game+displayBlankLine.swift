extension Game{
    
    mutating func displayBlankLine() {
        if debug {print("displayBlankLine()")}
        messageEntries.append(MessageEntry(line: "                                                            "))
    }
    
}

