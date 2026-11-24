extension Game {
    mutating func attackStarbase() {
        if debug {print("attackStarbase()")}
        var starbaseNumber = 0
        var quadrantNumber = 0
        // Check if any Quadrants contain a Starbase and enemy ships
        for i in 1...starbasesRemaining {
            quadrantNumber = galaxy[starbase[i][0]][starbase[i][1]]
            if quadrantNumber > 99 && quadrantNumber % 100 > 9 {
                starbaseUnderAttack = true
                starbaseNumber = i
                starbase[i][2] = 2  // RED
                starbase[1][3] = 0 // Repair efficiency = 0
                if quadrantNumber > 999 { //Romulan
                    
                    // If Romulan then romulansShootingAtEnterprise
                    romulansShootingAtStarbase(starbaseNumber: starbaseNumber, quadrantRow: starbase[starbaseNumber][0], quadrantCol: starbase[starbaseNumber][1])
                } else { // Klingon
                    
                    // If Klingons then klingonsShootingAtEnterprise
                    klingonsShootingAtStarbase(starbaseNumber: starbaseNumber, quadrantRow: starbase[starbaseNumber][0], quadrantCol: starbase[starbaseNumber][1])
                }
                
                // Starbase can return fire either with Phasers or Photon Torpedoes
            }
        }
        for i in 1...starbasesRemaining {
            quadrantNumber = galaxy[starbase[i][0]][starbase[i][1]]
            if quadrantNumber < 100  && quadrantNumber % 100 > 9 {
                starbaseNumber = i
                if starbase[i][2] == 2 { // Condition RED
                    starbase[i][2] = 1 // Condition YELLOW
                    messageEntries.append(MessageEntry(line: "*** STARBASE AT QUADRANT \(starbase[i][0]),\(starbase[i][1]) CARRYING OUT REPAIRS AFTER ATTACK ***"))
                    messageEntries.append(MessageEntry(line: "*** UNABLE TO REPAIR ENTERPRISE BUT ABLE TO SUPPLY ENERGy & WEAPONS  ****"))
                    starbaseUnderAttack = false}
            }
        }
        for i in 1...starbasesRemaining {
            quadrantNumber = galaxy[starbase[i][0]][starbase[i][1]]
            if quadrantNumber < 100  && quadrantNumber % 100 > 9 {
                starbaseNumber = i
                if starbase[i][2] == 1 { // Condition YELLOW
                    starbase[i][2] = 0 // Condition GREEN
                    starbase[1][3] = 75 + Int.random(in: 0...25) // Repair efficiency =
                    messageEntries.append(MessageEntry(line: "*** STARBASE AT QUADRANT \(starbase[i][0]),\(starbase[i][1]) REPAIRS COMPLETED ***"))
                    messageEntries.append(MessageEntry(line: "*** REPAIR EFFICIENCY NOW \(starbase[1][3])% ***"))
                    starbaseUnderAttack = false}
            }
        }
        // If all enemy ships destroyed then Starbase returns to condition yellow (if reserves low) or green (if reserves more than defined amount)
    }
}
