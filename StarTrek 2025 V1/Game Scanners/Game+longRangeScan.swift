extension Game {
    
    mutating func longRangeScan() {
        if debug {print("longRangeScan()")}
        displayBlankLine()
        if enterpriseDamage[Constants.SystemNumber.longRangeSensors] < 0.9 {
            messageEntries.append(MessageEntry(line: "*** LONG RANGE SENSORS ARE OUT ***"))
        } else {
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "LONG RANGE SCAN FROM QUADRANT \(quadrantCoordinates.0),\(quadrantCoordinates.1)"))
            displayBlankLine()
            temp$ = ""
            if (quadrantCoordinates.1)-1 < 1 {temp$ = "  ...*.."}
            else {temp$ = "  ...\((quadrantCoordinates.1)-1).."}
            temp$ = temp$ + "...\(quadrantCoordinates.1).."
            if (quadrantCoordinates.1)+1 > 8 {temp$ = temp$ + "...*..."}
            else {temp$ = temp$ + "...\(quadrantCoordinates.1+1)..."}
            messageEntries.append(MessageEntry(line: temp$))
            messageEntries.append(MessageEntry(line: "  -------------------"))
            for i in quadrantCoordinates.0 - 1...quadrantCoordinates.0 + 1 {
                lrs[1] = -1
                lrs[2] = -2
                lrs[3] = -3
                for j in quadrantCoordinates.1 - 1...quadrantCoordinates.1 + 1 {
                    if i > 0 && i < 9 && j > 0 && j < 9 {
                        lrs[j - quadrantCoordinates.1 + 2] = galaxy[i][j]
                        explored[i][j] = galaxy[i][j]
                    }
                }
                temp$ = "\(i)|"
                if i<1 || i>8 {temp$ = "*|"}
                for l in 1...3 {
                    temp$ = temp$ + ": "
                    if lrs[l] < 0 {
                        temp$ = temp$ + "*** "
                    } else {
                        temp$ = temp$ + String(lrs[l] + 1000).suffix(3) + " "
                    }
                }
                temp$ = temp$ + ":"
                messageEntries.append(MessageEntry(line: temp$))
                messageEntries.append(MessageEntry(line: "  -------------------"))
            }
            messageEntries.append(MessageEntry(line: "Quadrant contents on each side of the Enterprise (in centre) as 3-digit code for number of Klingons, Starbases and Stars. Example: 217 = 2 Klingons, 1 Starbase, 7 Stars."))
        }
        getCommand()
    }
    
}

