extension Game {
    
    mutating func getEnemyShipData(){
        if debug {print("getEnemyShipData()")}
        var s = ""
        displayBlankLine()
        if klingonsInQuadrant <= 0 && romulansInQuadrant <= 0 {
            messageEntries.append(MessageEntry(line: "SCIENCE OFFICER SPOCK REPORTS:"))
            messageEntries.append(MessageEntry(line: "Sensors show no enemy ships in this Quadrant."))
            return
        } else {
            if (klingonsInQuadrant > 1) {
                s = "s"
            }
            messageEntries.append(MessageEntry(line: "Enemy ship\(s) information:"))
            if klingonsInQuadrant > 0 {
                for i in 1...klingonsInQuadrant {
                    displayBlankLine()
                    messageEntries.append(MessageEntry(line: "Klingon at Sector \(klingons[i][1]),\(klingons[i][2]): Estimated fire power \(klingons[i][3]) units."))
                }
            }
            if romulansInQuadrant > 0 {
                for i in 1...romulansInQuadrant {
                    
                    // Only display energy if not cloaked
                    if romulans[i][4] == 0 {
                        displayBlankLine()
                        messageEntries.append(MessageEntry(line: "Romulan at Sector \(romulans[i][2]),\(romulans[i][3]): Estimated fire power \(romulans[i][5]) units."))
                    } else {
                        messageEntries.append(MessageEntry(line: "Romulan vessel somewhere in this Quadrant but location unknown. Estimated fire power \(romulans[i][5]) units."))
                    }
                }
            }
        }
        getCommand()
    }
}
