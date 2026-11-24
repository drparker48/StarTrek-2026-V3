extension Game {
    
    mutating func klingonsShootingAtStarbase (starbaseNumber:Int, quadrantRow:Int, quadrantCol:Int) {
        //Knows which Starbase is under attack and its Quadrant
        if debug {print("klingonsShootingAtStarbase()")}
        var hits = 0
        var klingonsInStarbaseQuadrant = 0
        var romulansInStarbaseQuadrant = 0
        var klingonEnergy = 0
        displayBlankLine()
        
        // Determine Quadrant and identify Starbase
        messageEntries.append(MessageEntry(line: "*** STARBASE AT QUADRANT \(quadrantRow),\(quadrantCol) UNDER ATTACK FROM KLINGONS ***"))
        displayBlankLine()
        if enterpriseCondition == "DOCKED" {
            messageEntries.append(MessageEntry(line: "*** ENTERPRISE SHIELDS PROTECT THE STARBASE ***"))
        } else {
            
            // Determine number of Klingons in Quadrant
            romulansInStarbaseQuadrant = galaxy[quadrantRow][quadrantCol]/1000
            temp = galaxy[quadrantRow][quadrantCol] - (romulansInStarbaseQuadrant * 1000)
            klingonsInStarbaseQuadrant = temp/100
            for _ in 1...klingonsInStarbaseQuadrant {
                klingonEnergy = Int.random(in: 200...400)
                let baseHit = Int.random(in: 80...160)
                hits = Int(Double(baseHit) * (Double(klingonEnergy) / 300.0))
                if debug { print("Klingon energy: \(klingonEnergy), computed hits: \(hits)") }
                if hits > 0 {
                    messageEntries.append(MessageEntry(line: "COMMUNICATIONS OFFICER REPORTS: Klingon firing at Starbase in Quadrant \(quadrantRow),\(quadrantCol) . . ."))
                    messageEntries.append(MessageEntry(line: ". . . \(hits) unit hit on Starbase in Quadrant \(quadrantRow),\(quadrantCol)"))
                    
                    // Reduce Starbase energy
                    starbase[starbaseNumber][4] -= hits
                    messageEntries.append(MessageEntry(line: "Starbase has \(starbase[starbaseNumber][4]) units remaining."))
                    displayBlankLine()
                    if debug {print("Starbase energy: \(starbase[starbaseNumber][3])")}
                    
                    // If Starbase energy <= 0 then Starbase destroyed
                    if starbase[starbaseNumber][4] <= 0 {
                        messageEntries.append(MessageEntry(line: "*** STARBASE IN QUADRANT \(quadrantRow),\(quadrantCol) DESTROYED ***"))
                        starbaseDestroyed = true
                        // If last Starbase then end game
                        if starbasesRemaining <= 0 {endGame(reason: "Starbase")
                            missionOver = true}
                    }
                }
            }
        }
    }
}
