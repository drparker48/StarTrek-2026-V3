extension Game {
    
    mutating func warpDrive(currentQuadrant: (Int, Int), targetQuadrant: (Int, Int)) -> (Int, Int) {
        if debug {print("warpDrive()")}
        var newQuadrant = currentQuadrant
        var previousQuadrant = currentQuadrant
        var movement = 0
        var repairFactor = 0.00
        var systemNumber = 0
        
        // Check if the destination is within bounds
        guard targetQuadrant.0 >= 1 && targetQuadrant.0 <= 8 && targetQuadrant.1 >= 1 && targetQuadrant.1 <= 8 else {
            messageEntries.append(MessageEntry(line: "LT. SULU REPORTS: Incorrect course data, Sir!"))
            return previousQuadrant
        }
        
        // Calculate distance and energy required
        movement = calculateDistance(from: currentQuadrant, to: targetQuadrant)
        if debug {print("Warp Drive movement: \(movement)")}
        enterpriseRequiredEnergy = Int(Double(calculateDistance(from: currentQuadrant, to: targetQuadrant)) * 8.0 + 0.5)
        if enterpriseEnergy < enterpriseRequiredEnergy {//Not enough energy so message and exit
            messageEntries.append(MessageEntry(line: "ENGINEERING REPORTS: Insufficient energy for moving to Quadrant \(targetQuadrant.0),\(targetQuadrant.1)!"))
            if enterpriseShields >= (enterpriseRequiredEnergy - enterpriseEnergy) && enterpriseDamage[Constants.SystemNumber.warpDrive] >= 0 {//Use shields to make up for shortage of energy as long as they're not damaged
                messageEntries.append(MessageEntry(line: "DEFLECTOR CONTROL REPORTS: \(enterpriseShields) units of energy presently deployed to Shields. Return energy to main banks to proceed."))
            }
            return targetQuadrant
        }
        
        // Check if Warp Drive damaged
        if enterpriseDamage[Constants.SystemNumber.warpDrive] < 0.9 {
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "DAMAGE CONTROL REPORT: Warp Drive is damaged - Maximum movement 2 Quadrants"))
            messageEntries.append(MessageEntry(line: "Current distance is \(movement) quadrants."))
            return targetQuadrant
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
        
        // Check for damage repaired during movement
        repairFactor = Double(movement)
        if debug {print ("repairFactor = \(repairFactor)")}
        for i in 1...8 {
            if enterpriseDamage[i] < 1.00 {
                enterpriseDamage[i] = enterpriseDamage[i] + repairFactor // Moving repairs
                if enterpriseDamage[i] > 1.00 { enterpriseDamage[i] = 1.00 }
                if enterpriseDamage[i] < 0.00 { enterpriseDamage[i] = 0.00 }
                if enterpriseDamage[i] >= 1.00 { messageEntries.append(MessageEntry(line: "DAMAGE CONTROL REPORTS: \(enterpriseSystems[i]) repair completed.")) }
            }
        }
        
        // Decide on damage or repair
        if Int.random(in:0...99) <= 2 {
            systemNumber = Int.random(in: 1...9)
            if Int.random(in: 0...99) >= 6 {
                enterpriseDamage[systemNumber] = enterpriseDamage[systemNumber] + Double.random(in: 0.00...1.00) * 0.3 + 0.1
                if enterpriseDamage[systemNumber] > 1.00 { enterpriseDamage[systemNumber] = 1.00 }
                if enterpriseDamage[systemNumber] < 0.00 { enterpriseDamage[systemNumber] = 0.00 }
                displayBlankLine()
                messageEntries.append(MessageEntry(line: "DAMAGE CONTROL REPORTS: \(enterpriseSystems[systemNumber]) state of repair improved."))
            } else {
                enterpriseDamage[systemNumber] = enterpriseDamage[systemNumber] - Double.random(in: 0.00...1.00) * 0.5 + 0.1
                if enterpriseDamage[systemNumber] > 1.00 { enterpriseDamage[systemNumber] = 1.00 }
                if enterpriseDamage[systemNumber] < 0.00 { enterpriseDamage[systemNumber] = 0.00 }
                displayBlankLine()
                messageEntries.append(MessageEntry(line: "DAMAGE CONTROL REPORTS: \(enterpriseSystems[systemNumber]) damaged."))
            }
        }
        // Move the Enterprise
        displayBlankLine()
        messageEntries.append(MessageEntry(line: "NAVIGATION REPORTS: Course laid in for Quadrant \(targetQuadrant.0),\(targetQuadrant.1)."))
        while newQuadrant != targetQuadrant {
            // Store the current Sector as the previous Sector
            previousQuadrant = newQuadrant
            
            // Determine the direction to move
            let deltaX = targetQuadrant.0 - newQuadrant.0
            let deltaY = targetQuadrant.1 - newQuadrant.1
            
            // Move one step in the direction
            if deltaX != 0 {
                newQuadrant.0 += deltaX > 0 ? 1 : -1
            }
            if deltaY != 0 {
                newQuadrant.1 += deltaY > 0 ? 1 : -1
            }
        }
        quadrantCoordinates = targetQuadrant
        quadrant = Array(repeating: Array(repeating: "   ", count: 9), count: 9)
        
        // Movement completed - Increment Stardate based on 1 Stardate per Quadrant moved
        enterpriseStardate += Int(Double(movement) + 0.5)
        missionDaysLeft -= Int(Double(movement) + 0.5)
        if missionDaysLeft <= 0 {
            endGame(reason: "Time")
            if debug {print("Enterprise Stardate: \(enterpriseStardate) Starting Stardate: \(missionStart) Days Left: \(missionDaysLeft)")}
            missionOver = true
        }
        enterNewQuadrant()
        consumeEnergy()
        checkIfDocked()
        return newQuadrant
    }
    
}
