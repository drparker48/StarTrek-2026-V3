extension Game {
    
    mutating func romulansShootingAtStarbase (starbaseNumber:Int, quadrantRow:Int, quadrantCol:Int) {
        if debug {print("romulansShootingAtStarbase)")}
        var hits = 0
        displayBlankLine()
        messageEntries.append(MessageEntry(line: "*** ROMULAN BIRD OF PREY DECLOAKING ****"))
        romulanCloaked = false
        if enterpriseCondition == "DOCKED" {
            messageEntries.append(MessageEntry(line: "*** STARBASE SHIELDS PROTECT THE ENTERPRISE ***"))
        } else {
            
            // Determine if Romulan in Quadrant
            if galaxy[quadrantRow][quadrantCol] > 999 {
                hits = Int.random(in: 200...500)
                if debug {print("Hits: \(hits)")}
                if hits > 0 {
                    messageEntries.append(MessageEntry(line: "COMMUNICATIONS OFFICER REPORTS: Romulan firing at Starbase in Quadrant \(quadrantRow),\(quadrantCol) . . ."))
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
