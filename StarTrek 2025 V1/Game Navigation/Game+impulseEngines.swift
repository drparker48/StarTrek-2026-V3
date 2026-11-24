extension Game {
    
    mutating func impulseEngines(currentSector: (Int, Int), targetSector: (Int, Int)) -> (Int, Int) {
        if debug {print("impulseEngines()")}
        var newSector = currentSector
        var previousSector = currentSector
        var movement = 0
        var systemNumber = 0
        let repairFactor = max(0.0, min(1.0, enterpriseDamage[Constants.SystemNumber.impulseEngines]))
        
        // Check if the destination is within bounds
        guard targetSector.0 >= 1 && targetSector.0 <= 8 && targetSector.1 >= 1 && targetSector.1 <= 8 else {
            messageEntries.append(MessageEntry(line: "LT. SULU REPORTS: Incorrect course data, Sir!"))
            return previousSector
        }
        
        // Calculate distance and energy required
        movement = calculateDistance(from: currentSector, to: targetSector)
        enterpriseRequiredEnergy = Int(Double(calculateDistance(from: currentSector, to: targetSector)) * 1.0 + 0.5)
        if enterpriseEnergy < enterpriseRequiredEnergy {//Not enough energy so message and exit
            messageEntries.append(MessageEntry(line: "ENGINEERING REPORTS: Insufficient energy for moving to Sector \(targetSector.0),\(targetSector.1)!"))
            if enterpriseShields >= (enterpriseRequiredEnergy - enterpriseEnergy) && enterpriseDamage[Constants.SystemNumber.impulseEngines] >= 0 {//Use shields to make up for shortage of energy as long as they're not damaged
                messageEntries.append(MessageEntry(line: "DEFLECTOR CONTROL REPORTS: \(enterpriseShields) units of energy presently deployed to Shields. Return energy to main banks to proceed."))
            }
            return targetSector
        }
        
        // Check if Impules Engines damaged
        if enterpriseDamage[Constants.SystemNumber.impulseEngines] < 0.9 {
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "DAMAGE CONTROL REPORTS: Impulse engines are damaged - Maximum movement 2 Sectors at a time."))
            messageEntries.append(MessageEntry(line: "Current distance is \(movement) sectors."))
            return targetSector
        }
        
        // Klingons move before Enterprise
        if klingonsInQuadrant != 0 {
            for i in 1...klingonsInQuadrant {
                quadrant[klingons[i][1]][klingons[i][2]] = "   "
                let coordinates = findEmptyPlaceinQuadrant()
                klingons[i][1] = coordinates.0
                klingons[i][2] = coordinates.1
                quadrant[klingons[i][1]][klingons[i][2]] = "+K+"
            }
            //Klingons fire before Enterprise moves
            klingonsShootingAtEnterprise()
            if enterpriseDestroyed {
                endGame(reason: "Destroyed")
                missionOver = true
            }
        }
        
        // Romulan moves before Enterprise
        if romulansInQuadrant != 0 {
            quadrant[romulans[romulanNumber][2]][romulans[romulanNumber][3]] = "   "
            let coordinates = findEmptyPlaceinQuadrant()
            romulans[romulanNumber][2] = coordinates.0
            romulans[romulanNumber][3] = coordinates.1
            romulans[romulanNumber][4] = 0
            romulanCloaked = false
            quadrant[romulans[romulanNumber][2]][romulans[romulanNumber][3]] = "=R="
            
            //Romulan fires before Enterprise moves
            romulansShootingAtEnterprise()
            if enterpriseDestroyed {
                endGame(reason: "Destroyed")
                missionOver = true
            }
        }
        
        // No damage repaired during movement with Impulse Engines
        
        // No damage caused during movement with Impulse Engines
        
        // Move the Enterprise
        displayBlankLine()
        messageEntries.append(MessageEntry(line: "NAVIGATION REPORTS: Course laid in for Sector \(targetSector.0),\(targetSector.1)."))
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
            
            // Check if the new Sector contains an obstacle
            if quadrant[newSector.0][newSector.1] != "   " {
                quadrant[currentSector.0][currentSector.1] = "   "
                sectorCoordinates = previousSector
                quadrant[previousSector.0][previousSector.1] = "<*>"
                displayBlankLine()
                messageEntries.append(MessageEntry(line: "*** IMPULSE ENGINES SHUT DOWN AT SECTOR \(sectorCoordinates.0),\(sectorCoordinates.1) DUE TO BAD NAVIGATION ***"))
                // Check if collided with Romulan
                if debug {print(" newSector coordinates \(quadrant[newSector.0][newSector.1])")}
                if debug {print(" currentSector coordinates \(quadrant[currentSector.0][currentSector.1])")}
                if quadrant[newSector.0][newSector.1] == "=R=" {
                    // Check if cloaked and uncloak because of collision
                    messageEntries.append(MessageEntry(line: "*** CLOAKED ROMULAN IN SECTOR \(newSector.0),\(newSector.1) ***"))
                    romulans[romulanNumber][4] = 0
                    romulanCloaked = false
                    messageEntries.append(MessageEntry(line: "*** ROMULAN NOW VISIBLE IN SECTOR \(newSector.0),\(newSector.1) ***"))
                }
                checkIfDocked()
                shortRangeScan()
                return previousSector
            }
            // Decide on damage or repair
            if Double.random(in: 0...1) <= 0.02 * repairFactor {
                systemNumber = Int.random(in: 1...9)
                if Double.random(in: 0...1) <= (0.94 * repairFactor) {
                    enterpriseDamage[systemNumber] = enterpriseDamage[systemNumber] + (Double.random(in: 0.00...1.00) * 0.3 + 0.1) * (1.0 - repairFactor)
                    if enterpriseDamage[systemNumber] > 1.00 {
                        enterpriseDamage[systemNumber] = 1.00
                        displayBlankLine()
                        messageEntries.append(MessageEntry(line: "DAMAGE CONTROL REPORTS: \(enterpriseSystems[systemNumber]) state of repair improved."))
                    }
                } else {
                    enterpriseDamage[systemNumber] = enterpriseDamage[systemNumber] - (Double.random(in: 0.00...1.00) * 0.5 + 0.1) * repairFactor
                    if enterpriseDamage[systemNumber] < 0.0 { enterpriseDamage[systemNumber] = 0.0 }
                    displayBlankLine()
                    messageEntries.append(MessageEntry(line: "DAMAGE CONTROL REPORTS: \(enterpriseSystems[systemNumber]) damaged."))
                }
            }
            // Move the object to the new Sector
            quadrant[previousSector.0][previousSector.1] = "   "
            sectorCoordinates = newSector
            quadrant[newSector.0][newSector.1] = "<*>"
        }
        // Movement completed - Increment Stardate based on 9 sectors per quadrant
        enterpriseStardate += Int(Double(movement)/9 + 0.5)
        missionDaysLeft -= Int(Double(movement)/9 + 0.5)
        if missionDaysLeft <= 0 {
            if debug {print("Enterprise Stardate: \(enterpriseStardate) Starting Stardate: \(missionStart) Days Left: \(missionDaysLeft)")}
            endGame(reason: "Time")
            missionOver = true
        }
        consumeEnergy()
        checkIfDocked()
        return newSector
    }
    
}
