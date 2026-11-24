extension Game {
    
    // MARK: Scanner Functions
    
    mutating func shortRangeScan() {
        if debug {print("shortRangeScan()")}
        enterpriseCondition = checkShipStatus()
        displayBlankLine()
        if enterpriseDamage[Constants.SystemNumber.shortRangeSensors] < 0.9 {
            messageEntries.append(MessageEntry(line: "*** SHORT RANGE SENSORS ARE OUT ***"))
        } else {
            messageEntries.append(MessageEntry(line: "SHORT RANGE SCAN FOR QUADRANT \(quadrantCoordinates.0),\(quadrantCoordinates.1)"))
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "    1  2  3  4  5  6  7  8                                     "))
            messageEntries.append(MessageEntry(line: "   ------------------------                                    "))
            var mySubstring: Substring
            var myString: String
            mySubstring = ""
            for i in 1...8 {
                mySubstring = "\(i)|"
                for j in 1...8 {
                    if quadrant[i][j] == "=R=" && romulanCloaked {
                        mySubstring = mySubstring + "   "
                    } else {
                        mySubstring = mySubstring + quadrant[i][j]
                    }
                    //mySubstring = mySubstring + quadrant[i][j]
                }
                switch i{
                case 1:
                    mySubstring = mySubstring + "  STARDATE \(enterpriseStardate)"
                case 2:
                    mySubstring = mySubstring + "  CONDITION \(enterpriseCondition)"
                case 3:
                    mySubstring = mySubstring + "  QUADRANT \(quadrantCoordinates.0),\(quadrantCoordinates.1)"
                case 4:
                    mySubstring = mySubstring + "  SECTOR \(sectorCoordinates.0),\(sectorCoordinates.1)"
                case 5:
                    mySubstring = mySubstring + "  PHOTON TORPEDOES \(enterpriseTorpedoes)"
                case 6:
                    mySubstring = mySubstring + "  ENERGY \(enterpriseEnergy)"
                case 7:
                    mySubstring = mySubstring + "  SHIELDS \(enterpriseShields)"
                case 8:
                    mySubstring = mySubstring + "  KLINGONS REMAINING \(klingonsRemaining)"
                default:
                    print("Error")
                }
                myString = mySubstring.padding(toLength: 60, withPad: " ", startingAt: 0)
                messageEntries.append(MessageEntry(line: String(myString)))
            }
            messageEntries.append(MessageEntry(line: "   ------------------------                                    "))
            messageEntries.append(MessageEntry(line: "<*> Enterprise +K+ Klingon =R= Romulan >!< Starbase  *  Star"))
            explored[quadrantCoordinates.0][quadrantCoordinates.1] = galaxy[quadrantCoordinates.0][quadrantCoordinates.1]
        }
        getCommand()
    }
    
}

