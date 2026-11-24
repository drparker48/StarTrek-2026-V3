extension Game {
    
    mutating func getStarbaseNavData() {
        if debug {print("getStarbaseNavData()")}
        displayBlankLine()
        if starbasesRemaining > 1 {messageEntries.append(MessageEntry(line: "The Federation is maintaining \(starbasesRemaining) starbases in the Galaxy."))}
        else {messageEntries.append(MessageEntry(line: "The Federation is maintaining 1 starbase in the Galaxy."))}
        for i in 1...starbasesRemaining {
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "Starbase \(i) at Quadrant \(starbase[i][0]),\(starbase[i][1]). Condition \(condition[starbase[i][2]])."))
            messageEntries.append(MessageEntry(line: " Repair Efficiency \(starbase[i][3])%. Energy \(starbase[i][4]) units. Photon Torpedoes \(starbase[i][5])."))
        }
        if debug {
            for  i in 0...6 {
                for j in 0...5 {
                    print("\(i), \(j), \(starbase[i][j])")
                }
                print(galaxy[starbase[i][0]][starbase[i][1]])
            }
        }
        getCommand()
    }
}
