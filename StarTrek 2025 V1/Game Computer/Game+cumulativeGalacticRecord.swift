extension Game {
    // MARK: Computer Functions
    
    mutating func cumulativeGalacticRecord(regionNameMap: Bool) {
        if debug {print("cumulativeGalacticRecord()")}
        var count: Int
        var myString: String
        let spaces = "            "
        var temp: Substring
        displayBlankLine()
        if regionNameMap {
            messageEntries.append(MessageEntry(line: "GALAXY REGION MAP"))
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "          1     2     3     4     5     6     7     8        "))
            messageEntries.append(MessageEntry(line: "        ----- ----- ----- ----- ----- ----- ----- -----      "))
            for i in 0...7 {
                myString = ""
                count = gQuadrantNames[0][i].count
                temp = spaces.prefix((24 - count)/2)
                myString = temp + gQuadrantNames[0][i]
                temp = spaces.prefix(24 - myString.count)
                myString = myString + temp
                count = gQuadrantNames[1][i].count
                temp = spaces.prefix((24 - count)/2)
                myString = myString + temp + gQuadrantNames[1][i]
                myString = String(i + 1) + "  " + myString
                myString = myString.padding(toLength: 50, withPad: " ", startingAt: 0)
                messageEntries.append(MessageEntry(line: String(myString)))
                messageEntries.append(MessageEntry(line: "        ----- ----- ----- ----- ----- ----- ----- -----      "))
            }
        } else {
            messageEntries.append(MessageEntry(line: "CUMULATIVE RECORD OF GALAXY FOR QUADRANT \(quadrantCoordinates.0),\(quadrantCoordinates.1)"))
            messageEntries.append(MessageEntry(line: "Results of all Short and Long Range Scans."))
            messageEntries.append(MessageEntry(line: "          1     2     3     4     5     6     7     8        "))
            messageEntries.append(MessageEntry(line: "        ----- ----- ----- ----- ----- ----- ----- -----      "))
            for i in 1...8 {
                lrs[1] = -1
                lrs[2] = -2
                lrs[3] = -3
                lrs[4] = -4
                lrs[5] = -5
                lrs[6] = -6
                lrs[7] = -7
                lrs[8] = -8
                temp$ = String(i) + " "
                for j in 1...8 {
                    if i > 0 && i < 9 && j > 0 && j < 9 {
                        lrs[j] = explored[i][j]
                    }//END if
                }//NEXT j
                for l in 1...8 {
                    temp$ = temp$ + ": "
                    if lrs[l] <= 0 {
                        temp$ = temp$ + "*** "
                    } else {
                        temp$ = temp$ + String(lrs[l] + 1000).suffix(3) + " "
                    }//END if
                }//NEXT l
                temp$ = temp$ + ":"
                messageEntries.append(MessageEntry(line: temp$))
                messageEntries.append(MessageEntry(line: "        ----- ----- ----- ----- ----- ----- ----- -----      "))
            }//NEXT i
            messageEntries.append(MessageEntry(line: "3-digit codes: number of Klingons, Starbases and Stars. Example, 217 = 2 Klingons, 1 Starbase and 7 Stars."))
        }
        getCommand()
    }
    
}
