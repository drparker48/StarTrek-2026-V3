extension Game {
    // MARK: Game Control Functions - Start Game
    mutating func startGame() {
        if debug {print("startGame()")}
        
        // Intialise game elements - set up initial values.
        var starbases = "Starbase"
        
        // Clear arrays
        enterpriseDamage = Array(repeating: 1.00, count: 10) // 100%
        for index in 0..<enterpriseDamage.count {
            enterpriseDamage[index] = 1.00
        }
        messageEntries.removeAll()
        klingons = [[Int]](repeating: [Int](repeating: 0, count: 4), count: 4)
        romulans = [[Int]](repeating: [Int](repeating: 0, count: 6), count: 4)
        quadrant = Array(repeating: Array(repeating: "   ", count: 9), count: 9)
        
        // Setup Game status - set up game status variables like gameStarted, gameOver, and adjusting daysLeft.
        missionStarted = false
        missionOver = false
        
        // Consider changing daysLeft to 25 + Int.random(in:1...klingonsStarting) to increase or reduce the number of days available
        
        missionDaysLeft = 25 + Int.random(in:1...10) //T9 Set to 25 + Int.random(in:1...10)
        
        // Initialise Enterprise status - initialise of Enterprise status variables like enterpriseCondition, enterpriseDocked, enterpriseEnergy, etc.
        enterpriseCondition = "GREEN" //C$
        enterpriseDocked = false // D0 docked flag (set to 0 = false at start) to indicate whether Enterprise is docked or not
        enterpriseEnergy = Constants.Game.originalEnergy - 1000 //E initial energy = 3000
        enterpriseShields = 1000 //S shields
        enterpriseStardate = Constants.Game.originalStardate + Int.random(in:1...20) * 100//T current stardate from 2,000 to 4,000
        missionStart = enterpriseStardate
        enterpriseSystemsDamaged = false
        enterpriseTorpedoes = Constants.Game.originalTorpedoes //P number of torpedoes
        
        // Populate Galaxy -  populate the galaxy with Klingons, Romulans, Starbases, and Stars in each quadrant.
        explored = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
        galaxy = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
        damageRepairTime = 0
        
        // Position Enterprise at random location.
        sectorCoordinates.0 = Int.random(in:1...8)//S1
        sectorCoordinates.1 = Int.random(in:1...8) //S2
        quadrantCoordinates.0 = Int.random(in:1...8) //Q1
        quadrantCoordinates.1 = Int.random(in:1...8) //Q2
        if debug {print("Enterprise randomly located in Quadrant \(quadrantCoordinates.0),\(quadrantCoordinates.1) Sector \(sectorCoordinates.0),\(sectorCoordinates.1)")}
        
        // Klingons at start
        klingonsStarting = 0 //K7
        klingonsRemaining = 0 //K9 klingons
        
        // Romulans at start
        romulansStarting = 0 //
        romulansRemaining = 0 //
        
        // Starbases at start
        starbasesRemaining = 0 //B9 starbases
        
        // Populate galaxy
        for i in 1...8 {
            for j in 1...8 {
                
                // Set quadrant contents to zero
                klingonsInQuadrant = 0 //Start with 0 Klingons
                starbasesInQuadrant = 0// and no Starbases
                romulansInQuadrant = 0 // and no Romulans
                galaxy[i][j] = 0 //Clear unknown galaxy quadrant
                explored[i][j] = 0 //Clear known galaxy quadrant
                
                // Determine number of Klingons per quadrant
                switch Int.random(in:1...99) {
                case 98...99 : //Add 3 Klingons
                    klingonsInQuadrant = 3
                    klingonsRemaining += 3
                case 95..<98: //Add 2 Klingons
                    klingonsInQuadrant = 2
                    klingonsRemaining += 2
                case 88..<95: //Add 1 Klingon
                    klingonsInQuadrant = 1
                    klingonsRemaining += 1
                default: //Add no Klingons
                    klingonsInQuadrant = 0
                }
                
                // Add a Romulan if required in either Antares or Spica regions
                if (i == 1 && j <= 4 || i == 8 && j >= 5)   && Int.random(in:1...99) > 94 { //Add 1 Romulan
                    romulansInQuadrant = 1
                    romulansRemaining += 1
                    romulans[romulansRemaining][0] = i // Quadrant coordinates
                    romulans[romulansRemaining][1] = j // Quadrant coordinates
                    romulans[romulansRemaining][2] = 0 // Sector coordinates assigned when entering the quadrant
                    romulans[romulansRemaining][3] = 0 // Sector coordinates assigned when entering the quadrant
                    romulans[romulansRemaining][5] = Int(Double(Constants.Game.originalRomulanEnergy) * (Double.random(in: 0.50..<1.50))) // Energy
                }
                
                // Add Starbase if required
                if Int.random(in: 1...99) > 96 && starbasesRemaining <= 5 { //Add 1 Starbase
                    starbasesInQuadrant = 1
                    starbasesRemaining += 1
                    starbase[starbasesRemaining][0] = i
                    starbase[starbasesRemaining][1] = j
                    starbase[starbasesRemaining][2] = 0 // Condition GREEN
                    starbase[starbasesRemaining][3] = Int.random(in:90..<100)
                    starbase[starbasesRemaining][4] = 10000
                    starbase[starbasesRemaining][5] = 200
                }
                
                // Add stars
                starsInQuadrant = Int.random(in:1...8) //Add between 1 and 8 Stars
                
                // Code contents of quadrant into Galaxy
                galaxy[i][j] = romulansInQuadrant * 1000 + klingonsInQuadrant * 100 + starbasesInQuadrant * 10 + starsInQuadrant
                if debug {print("Galaxy Quadrant \(i),\(j) has \(klingonsInQuadrant) Klingon, \(romulansInQuadrant) Romulan, \(starbasesInQuadrant) Starbase and \(starsInQuadrant) Stars")}
            }
            
            // If the number of Klingons is greater than the days left increase days left by one.
            if klingonsRemaining > missionDaysLeft {
                missionDaysLeft = klingonsRemaining + 1
            }
        }
        
        // If there are no Starbases in the galaxy
        if starbasesRemaining == 0 { //If there are no Starbases in the galaxy
            if galaxy[quadrantCoordinates.0][quadrantCoordinates.1] < 200 { //If there are less than 2 Klingons in the Enterprise Quadrant then add 1
                galaxy[quadrantCoordinates.0][quadrantCoordinates.1] += 100
                klingonsRemaining += 1
            }
            starbasesRemaining = 1 //Add a Starbase in the Enterprise Quadrant
            starbase[starbasesRemaining][0] = quadrantCoordinates.0
            starbase[starbasesRemaining][1] = quadrantCoordinates.1
            starbase[starbasesRemaining][2] = 0 // Condition GREEN
            starbase[starbasesRemaining][3] = Int.random(in:90..<100)
            starbase[starbasesRemaining][4] = 10000
            starbase[starbasesRemaining][5] = 200
            galaxy[quadrantCoordinates.0][quadrantCoordinates.1] += 10
            quadrantCoordinates.0 = Int.random(in:1...8) // Reposition the Enterprise
            quadrantCoordinates.1 = Int.random(in:1...8)
            sectorCoordinates.0 = Int.random(in:1...8)//S1
            sectorCoordinates.1 = Int.random(in:1...8) //S2
            if debug {
                print("Enterprise repositioned in Quadrant \(quadrantCoordinates.0),\(quadrantCoordinates.1) Sector \(sectorCoordinates.0),\(sectorCoordinates.1)")}
        }
        klingonsStarting = klingonsRemaining
        romulansStarting = romulansRemaining
        if debug {print("Klingons = \(klingonsRemaining), Romulans = \(romulansRemaining), Starbases = \(starbasesRemaining)")}
        quadrant = Array(repeating: Array(repeating: "   ", count: 9), count: 9)
        
        // Display mission
        let verb = (starbasesRemaining == 1) ? "is" : "are"
        let klingonNoun = (klingonsRemaining == 1) ? "Klingon warship" : "Klingon warships"
        let dayNoun = (missionDaysLeft == 1) ? "day" : "days"
        if (starbasesRemaining != 1) {//Set up correct syntax for Starbase quantity
            starbases = "Starbases"
        }
        missionDays = missionDaysLeft
        messageEntries.append(MessageEntry(line: "               THE USS ENTERPRISE --- NCC-1701              "))
        displayBlankLine()
        messageEntries.append(MessageEntry(line: "Stardate \(enterpriseStardate). Mission: Destroy \(klingonsRemaining) \(klingonNoun) invading the Galaxy before they can attack Federation Headquarters on Stardate \(enterpriseStardate + missionDaysLeft), giving you \(missionDaysLeft) \(dayNoun) to complete your mission. There \(verb) \(starbasesRemaining) \(starbases) to supply and repair your ship."))
        if romulansStarting > 0 {
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "Powerful Romulan Birds-of-Prey are on the edges of the Galaxy in Arcturus or Spica regions. Cloaking devices make them invisible unless they are materialising to attack."))
        }
        displayBlankLine()
        messageEntries.append(MessageEntry(line: "Press Resign Command to reject the mission, New Mission for a different mission or use the buttons below to take command. "))
        displayBlankLine()
        
        // Enter quadrant
        enterNewQuadrant()
        
        // Identify condition and warn accordingly
        //getCommand()
    }
}

