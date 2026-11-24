extension Game {
    
    
    mutating func fireTorpedoes(currentSector: (Int, Int), targetSector: (Int, Int)) -> (Int, Int) {
        if debug {print("fireTorpedoes()")}
        var newSector = currentSector
        var previousSector = currentSector
        var destroyedKlingonIndex: Int? = nil
        var basesInQuadrant = 0
        var nothingFound = true
        
        // Check if torpedoes are available
        displayBlankLine()
        if enterpriseTorpedoes <= 0 {
            messageEntries.append(MessageEntry(line: "*** ALL PHOTON TORPEDOES EXPENDED ***"))
            return previousSector
        }
        
        // Check if photon tubes are operational
        if enterpriseDamage[Constants.SystemNumber.photonTubes] < 0.9 {
            messageEntries.append(MessageEntry(line: "*** PHOTON TUBES ARE NOT OPERATIONAL ***"))
            return previousSector
        }
        enterpriseTorpedoes -= 1
        messageEntries.append(MessageEntry(line: "Torpedo track:"))
        while newSector != targetSector {
            
            // Store the current Sector as the previous Sector
            previousSector = newSector
            
            // Determine the direction to move
            let deltaX = targetSector.0 - newSector.0
            let deltaY = targetSector.1 - newSector.1
            
            // Move one step in the direction
            if deltaX != 0 {
                newSector.0 += deltaX > 0 ? 1 : -1
            }
            if deltaY != 0 {
                newSector.1 += deltaY > 0 ? 1 : -1
            }
            
            // Check if out of bounds
            if (newSector.0 < 1) || (newSector.0 > 8) || (newSector.1 < 1) || (newSector.1 > 8) {//Torpedo is out of bounds
                messageEntries.append(MessageEntry(line: "*** TORPEDO MISSED ***"))
                break
            }
            messageEntries.append(MessageEntry(line: "----------> \(newSector.0),\(newSector.1)"))
            if quadrant[newSector.0][newSector.1] == "   " {
                
                //Found clear space so carry on
            } else {
                
                // Could be a Klingon, Romulan, Star or Starbase - used Switch statement
                switch quadrant[newSector.0][newSector.1] {
                case "+K+": //Found a Klingon
                    nothingFound = false
                    messageEntries.append(MessageEntry(line: "*** KLINGON DESTROYED ***"))
                    klingonsInQuadrant -= 1
                    enterpriseCondition = checkShipStatus()
                    
                    //Check which Klingon has been destroyed
                    for i in 1...3 {
                        if newSector.0 == klingons[i][1] && newSector.1 == klingons[i][2] {
                            klingons[i][3] = 0
                            quadrant[klingons[i][1]][klingons[i][2]] = "   "
                            destroyedKlingonIndex = i
                        }
                    }
                    if let idx = destroyedKlingonIndex {
                        messageEntries.append(MessageEntry(line: "Destroyed Klingon #\(idx) at \(newSector.0),\(newSector.1)"))
                    }
                    if klingonsInQuadrant == 0 {
                        messageEntries.append(MessageEntry(line: "Last Klingon in Quadrant destroyed."))
                        enterpriseCondition = "GREEN"
                        
                        //Check Starbase condition
                        if debug {print("Enterprise Condition = \(enterpriseCondition)")}
                        if enterpriseCondition == "GREEN" {
                            if starbasesInQuadrant > 0 {
                                
                                // Change status to YELLOW if there is a Starbase in quadrant
                                locateStarbase(quadrantCoordinates: (quadrantCoordinates.0, quadrantCoordinates.1))
                                starbase[starbaseNumber][2] = 1
                                
                                // Reduce repair efficiency of starbase
                                starbase[starbaseNumber][3] = 50
                                if debug {print("Starbase at Quadrant \(starbase[starbaseNumber][0]),\(starbase[starbaseNumber][1]) now at Condition = YELLOW")}
                                messageEntries.append(MessageEntry(line: "Starbase in this Quadrant now at Condition = YELLOW."))
                            }
                        }
                    }
                    klingonsRemaining -= 1
                    galaxy[quadrantCoordinates.0][quadrantCoordinates.1] -= 100
                    explored[quadrantCoordinates.0][quadrantCoordinates.1] = galaxy[quadrantCoordinates.0][quadrantCoordinates.1]
                    if klingonsRemaining <= 0 {
                        endGame(reason: "Success")
                        missionOver = true
                    }
                    if klingonsInQuadrant > 0 {klingonsShootingAtEnterprise()}
                    if klingonsRemaining == 0 {
                        endGame(reason: "Success")
                        missionOver = true
                    }
                case "=R=": //Found a Romulan
                    nothingFound = false
                    messageEntries.append(MessageEntry(line: "*** ROMULAN DESTROYED ***"))
                    romulansInQuadrant -= 1
                    enterpriseCondition = checkShipStatus()
                    romulansRemaining -= 1
                    quadrant[newSector.0][newSector.1] = "   "
                    galaxy[quadrantCoordinates.0][quadrantCoordinates.1] -= 1000
                    explored[quadrantCoordinates.0][quadrantCoordinates.1] = galaxy[quadrantCoordinates.0][quadrantCoordinates.1]
                    if romulansRemaining == 0 {
                        messageEntries.append(MessageEntry(line: "NO ROMULANS REMAINING IN THE GALAXY"))
                    } else {
                        messageEntries.append(MessageEntry(line: "Sensors show \(romulansRemaining) Romulan(s) remaining in the galaxy."))
                    }
                case ">!<": //Found a Starbase
                    nothingFound = false
                    messageEntries.append(MessageEntry(line: "Starbase at \(newSector.0),\(newSector.1) destroyed"))
                    basesInQuadrant -= 1
                    removeStarbase(starbaseCoordinates: (quadrantCoordinates.0,quadrantCoordinates.1))
                    starbasesRemaining -= 1
                    quadrant[newSector.0][newSector.1] = "   "
                    galaxy[quadrantCoordinates.0][quadrantCoordinates.1] -= 10
                    explored[quadrantCoordinates.0][quadrantCoordinates.1] = galaxy[quadrantCoordinates.0][quadrantCoordinates.1]
                    if starbasesRemaining > 0 || klingonsRemaining > enterpriseStardate - missionStart - missionDaysLeft {
                        messageEntries.append(MessageEntry(line: "Starfleet Command reviewing your record to consider Court Martial!"))
                        //shipDocked = false
                        break
                    } else {
                        messageEntries.append(MessageEntry(line: "Last Starbase destroyed"))
                        endGame(reason: "Last Starbase destroyed")
                        missionOver = true
                    }
                case " * ": //Found a Star
                    nothingFound = false
                    if quadrant[newSector.0][newSector.1] == " * " {
                        messageEntries.append(MessageEntry(line: "Star at \(newSector.0),\(newSector.1) absorbed Torpedo energy."))
                        break
                    }
                default: //Found something else
                    nothingFound = false
                    messageEntries.append(MessageEntry(line: "Unknown vessel collision."))
                }
                
                if (klingonsInQuadrant != 0){klingonsShootingAtEnterprise()} // Klingons shoot back
                if (romulansInQuadrant != 0){romulansShootingAtEnterprise()} // Romulans shoot back}
            }
        }
        if nothingFound {
            messageEntries.append(MessageEntry(line: "Torpedo missed all targets."))
        }
        return previousSector
    }
}

