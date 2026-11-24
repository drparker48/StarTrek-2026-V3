extension Game {
    
    mutating func getDebugData() {
        if debug {print("getDebugData()")}
        displayBlankLine()
        messageEntries.append(MessageEntry(line: "KLINGONS IN THIS QUADRANT"))
        displayBlankLine()
        if klingonsInQuadrant > 0 {
            if debug {print("Klingons in Quadrant \(klingonsInQuadrant)")}
            for i in 1...klingonsInQuadrant {
                messageEntries.append(MessageEntry(line: "Klingon \(i) at Sector \(klingons[i][1]),\(klingons[i][2]) with \(klingons[i][3]) units of energy."))
            }
            displayBlankLine()
        } else {
            messageEntries.append(MessageEntry(line: "No Klingons in this Quadrant."))
        }
        displayBlankLine()
        if romulansRemaining > 0 {
            if debug {print("Romulans remaining \(romulansRemaining)")}
            messageEntries.append(MessageEntry(line: "ROMULANS IN GALAXY"))
            for i in 1...romulansRemaining {
                displayBlankLine()
                messageEntries.append(MessageEntry(line: "Romulan \(i) at Quadrant \(romulans[i][0]),\(romulans[i][1]). Energy \(romulans[i][5])."))
            }
        } else {
            messageEntries.append(MessageEntry(line: "No Romulans in the Galaxy."))
        }
        displayBlankLine()
        messageEntries.append(MessageEntry(line: "GALACTIC MAP"))
        displayBlankLine()
        messageEntries.append(MessageEntry(line: "       1      2      3      4      5      6      7      8        "))
        messageEntries.append(MessageEntry(line: "     ------ ------ ------ ------ ------ ------ ------ ------     "))
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
                    lrs[j] = galaxy[i][j]
                }//END if
            }//NEXT j
            for l in 1...8 {
                temp$ = temp$ + ": "
                if lrs[l] <= 0 {
                    temp$ = temp$ + "*** "
                } else {
                    temp$ = temp$ + String(lrs[l] + 100000).suffix(4) + " "
                }//END if
            }//NEXT l
            temp$ = temp$ + ":"
            messageEntries.append(MessageEntry(line: temp$))
            messageEntries.append(MessageEntry(line: "     ------ ------ ------ ------ ------ ------ ------ ------     "))
        } //NEXT i
        getCommand()
    }
}
