extension Game {
    
    mutating func enterNewQuadrant () {
        if debug {print("enterNewQuadrant()")}
        
        // Initialise Quadrant counts -  reset the counts for Klingons, Romulans, starbases, and stars in the quadrant.
        klingonsInQuadrant = 0
        romulansInQuadrant = 0
        starbasesInQuadrant = 0
        starsInQuadrant = 0
        
        //Get Quadrant name and region -  determine the name of the quadrant and region based on quadrant coordinates.
        if quadrantCoordinates.0 <= 4 {
            eQuadrantName = gQuadrantNames[0][quadrantCoordinates.0 - 1]
        } else {
            eQuadrantName = gQuadrantNames[1][quadrantCoordinates.0 - 1]
        }
        if quadrantCoordinates.1 <= 4 {
            eQuadrantName = eQuadrantName + gSectorNames[quadrantCoordinates.1 - 1 ]
        } else {
            eQuadrantName = eQuadrantName + gSectorNames[quadrantCoordinates.1 - 5 ]
        }
        
        //Print Quadrant message
        if !missionStarted {//Print starting Quadrant
            messageEntries.append(MessageEntry(line: "Your mission begins with your starship located in the"))
            missionStarted = true
        } else {//Print entering new Quadrant
            messageEntries.append(MessageEntry(line: "Now entering . . .                         "))
        }
        messageEntries.append(MessageEntry(line: "\(eQuadrantName) Quadrant \(quadrantCoordinates.0),\(quadrantCoordinates.1) Sector \(sectorCoordinates.0),\(sectorCoordinates.1) "))
        
        //Get Quadrant contents - calculate the number of Romulans, Klingons, starbases, and stars in the quadrant based on galaxy data.
        romulansInQuadrant = galaxy[quadrantCoordinates.0][quadrantCoordinates.1]/1000
        temp = galaxy[quadrantCoordinates.0][quadrantCoordinates.1] - (romulansInQuadrant * 1000)
        klingonsInQuadrant = temp/100
        temp = temp - (klingonsInQuadrant * 100)
        starbasesInQuadrant = temp/10
        starsInQuadrant = temp - (starbasesInQuadrant * 10)
        if debug {print("Romulans: \(romulansInQuadrant) Klingons: \(klingonsInQuadrant) Bases: \(starbasesInQuadrant) Stars: \(starsInQuadrant)")}
        
        //Set Combat Condition - set combat conditions based on the presence of Klingons, Romulans, shield status, and Romulan cloaking.
        if klingonsInQuadrant > 0 || romulansInQuadrant > 0 {
            messageEntries.append(MessageEntry(line: "*** COMBAT AREA - CONDITION RED ***"))
            enterpriseCondition = "RED"
            if romulansInQuadrant > 0 {
                if romulanCloaked {
                    messageEntries.append(MessageEntry(line: "Romulan Warbird present but cloaked."))
                } else {
                    messageEntries.append(MessageEntry(line: "Romulan Warbird uncloaked."))
                }
            }
            if enterpriseShields < 400 {
                messageEntries.append(MessageEntry(line: "*** SHIELDS DANGEROUSLY LOW ***"))
            }
        }
        damageFactor = 0.5 * Double.random(in:0.1..<1.0)//D4=.5*RND(1) NOT SURE IF THIS IS BEING USED
        
        //Position Enterprise - position the Enterprise, Klingons, Romulans, starbase, and stars.
        quadrant[sectorCoordinates.0][sectorCoordinates.1] = "<*>"
        if debug {print("Enterprise positioned at Quadrant\(quadrantCoordinates.0),\(quadrantCoordinates.1) Sector \(sectorCoordinates.0),\(sectorCoordinates.1)")}
        
        //Position Klingons if there are any
        if klingonsInQuadrant > 0 {
            for i in 1...klingonsInQuadrant {
                let coordinates = findEmptyPlaceinQuadrant()
                quadrant[coordinates.0][coordinates.1] = "+K+"//Klingon
                klingons[i][1] = coordinates.0
                klingons[i][2] = coordinates.1
                klingons[i][3] = Int(Double(Constants.Game.originalKlingonEnergy) * (Double.random(in: 0.5..<1.5)))
                if debug {print("Klingon \(i) positioned at Quadrant\(quadrantCoordinates.0),\(quadrantCoordinates.1) Sector \(coordinates.0),\(coordinates.1) Energy \(klingons[i][3])")}
            }
        }
        
        //Position Romulans if there are any
        if romulansInQuadrant > 0 {
            // Find which Romulan it is is and position it
            romulanNumber = 0
            for i in 1...romulansRemaining {
                if romulans[i][0] == quadrantCoordinates.0 && romulans[i][1] == quadrantCoordinates.1 {
                    romulanNumber = i
                    let coordinates = findEmptyPlaceinQuadrant()
                    quadrant[coordinates.0][coordinates.1] = "=R="
                    romulans[romulanNumber][2] = coordinates.0
                    romulans[romulanNumber][3] = coordinates.1
                    romulans[romulanNumber][4] = 1 //Cloaked
                    if debug {print("Romulan \(i) positioned at Quadrant \(quadrantCoordinates.0),\(quadrantCoordinates.1) Sector \(coordinates.0),\(coordinates.1) Cloaked = \(romulans[i][4]) Energy \(romulans[i][5])")}
                    break
                }
            }
        }
        
        //Position Starbase if there is one
        if starbasesInQuadrant > 0 {
            let coordinates = findEmptyPlaceinQuadrant()
            quadrant[coordinates.0][coordinates.1] = ">!<"
            starbaseSectorCoordinates = coordinates
            messageEntries.append(MessageEntry(line: "STARBASE LOCATED AT SECTOR \(starbaseSectorCoordinates.0),\(starbaseSectorCoordinates.1)"))
        }
        
        //Position Stars
        for _ in 1...starsInQuadrant {
            let coordinates = findEmptyPlaceinQuadrant()
            quadrant[coordinates.0][coordinates.1] = " * "
        }
        // Launch attack on Starbase (skip if missionDaysLeft is negative resulting in invalid range)
        if starbasesInQuadrant > 0 {
            let endStardate = missionStart + missionDaysLeft
            if endStardate >= missionStart {
                let randomStardate = Int.random(in: missionStart...endStardate)
                if debug { print("randomStardate: \(randomStardate)") }
                if enterpriseStardate > randomStardate { attackStarbase() }
            } else {
                if debug { print("Skipping starbase attack scheduling: endStardate (\(endStardate)) < missionStart \(missionStart))") }
            }
        }
            
        getCommand()
    }
}
