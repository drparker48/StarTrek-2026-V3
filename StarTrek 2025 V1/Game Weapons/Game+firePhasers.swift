extension Game {
    
    // MARK: Weapons Functions
    
    mutating func firePhasers(unitsToFire: String) {
        if debug {print("firePhasers()")}
        var hits = 0
        var hits1 = 0.0
        var rangeA = 0.0
        var rangeB = 0.0
        var range = 0.0
        var unitsFired = 0
        displayBlankLine()
        if enterpriseDamage[Constants.SystemNumber.phaserControl] < 0.9 {
            messageEntries.append(MessageEntry(line: "*** PHASERS INOPERATIVE ****"))
        } else {
            if klingonsInQuadrant == 0 && romulansInQuadrant == 0 {
                messageEntries.append(MessageEntry(line: "SCIENCE OFFICER SPOCK REPORTS: Sensors show no enemy ships in this Quadrant."))
            } else {
                if enterpriseDamage[Constants.SystemNumber.libraryComputer] < 0.90 {
                    messageEntries.append(MessageEntry(line: "*** COMPUTER FAILURE HAMPERS ACCURACY ***"))
                }
                if unitsToFire == "0" {
                    messageEntries.append(MessageEntry(line: "Firing of Phasers CANCELLED"))
                    return
                }
                messageEntries.append(MessageEntry(line: "Phasers powering up . . ."))
                unitsFired = Int(unitsToFire) ?? 0
                enterpriseEnergy -= unitsFired
                if enterpriseDamage[Constants.SystemNumber.shieldControl] < 0.90 {
                    unitsFired = Int(Double(unitsFired) * Double.random(in: 0.01...1))
                }
                hits1 = Double(unitsFired / (klingonsInQuadrant + romulansInQuadrant))
                if debug {print("unitsFired = \(unitsFired) hits1 = \(hits1)")}
                // Fire on Klingons
                if klingonsInQuadrant > 0 {
                    for i in 1...3 {
                        if klingons[i][3] > 0 {
                            rangeA = Double((klingons[i][1] - sectorCoordinates.0) * (klingons[i][1] - sectorCoordinates.0))
                            rangeB = Double((klingons[i][2] - sectorCoordinates.1) * (klingons[i][2] - sectorCoordinates.1))
                            range = (rangeA + rangeB).squareRoot()
                            hits = Int((hits1 / Double(range)) * (Double.random(in: 0.01...1) + 2))
                            if debug {print("Klingon \(i) at \(klingons[i][1]),\(klingons[i][2]) range \(range) hits \(hits)")}
                            if hits <= (Int(Double(0.15) * Double(klingons[i][3]))) {
                                messageEntries.append(MessageEntry(line: "Sensors show no damage to enemy at \(klingons[i][1]),\(klingons[i][2])"))
                            } else {
                                klingons[i][3] = klingons[i][3] - hits
                                messageEntries.append(MessageEntry(line: "\(hits) unit hit to Klingon at Sector \(klingons[i][1]),\(klingons[i][2])"))
                            }
                            if klingons[i][3] <= 0 {
                                messageEntries.append(MessageEntry(line: "*** KLINGON DESTROYED ***"))
                                enterpriseCondition = checkShipStatus()
                                quadrant[klingons[i][1]][klingons[i][2]] = "   "
                                klingonsInQuadrant -= 1
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
                                if klingonsRemaining == 0 {
                                    endGame(reason: "Success")
                                    missionOver = true
                                }
                            } else {
                                messageEntries.append(MessageEntry(line: "Sensors show \(klingons[i][3]) units remaining."))
                            }
                            if klingonsInQuadrant > 0 {klingonsShootingAtEnterprise()}
                        }
                    }
                }
                
                // Are there Romulans in Quadrant and are they cloaked?
                if romulansInQuadrant > 0 && romulanCloaked  {
                    if debug {print("Romulan cloaked")}
                    messageEntries.append(MessageEntry(line: "Sensors unable to locate cloaked Romulan vessel."))
                    messageEntries.append(MessageEntry(line: ". . . Phasers powering down."))
                    romulansShootingAtEnterprise()
                    return
                }
                if romulansInQuadrant > 0 && !romulanCloaked {
                    if debug {print("Romulan being fired on")}
                }
                
                // Fire on Romulans
                if romulansInQuadrant > 0 {
                    if romulans[romulanNumber][5] > 0 {
                        rangeA = Double((romulans[romulanNumber][2] - sectorCoordinates.0) * (romulans[romulanNumber][2] - sectorCoordinates.0))
                        rangeB = Double((romulans[romulanNumber][3] - sectorCoordinates.1) * (romulans[romulanNumber][3] - sectorCoordinates.1))
                        range = (rangeA + rangeB).squareRoot()
                        hits = Int((hits1 / Double(range)) * (Double.random(in: 0.01...1) + 2))
                        if hits <= (Int(Double(0.15) * Double(romulans[romulanNumber][5]))) {
                            messageEntries.append(MessageEntry(line: "Sensors show no damage to enemy at \(romulans[romulanNumber][2]),\(romulans[romulanNumber][3])"))
                        } else {
                            romulans[romulanNumber][5] -= hits
                            messageEntries.append(MessageEntry(line: "\(hits) unit hit to Romulan at Sector \(romulans[romulanNumber][2]),\(romulans[romulanNumber][3])"))
                        }
                        if romulans[romulanNumber][5] <= 0 {
                            messageEntries.append(MessageEntry(line: "*** ROMULAN DESTROYED ***"))
                            enterpriseCondition = checkShipStatus()
                            romulansInQuadrant = romulansInQuadrant - 1
                            romulansRemaining = romulansRemaining - 1
                            quadrant[romulans[romulanNumber][2]][romulans[romulanNumber][3]] = "   "
                            romulans[romulanNumber][5] = 0
                            galaxy[quadrantCoordinates.0][quadrantCoordinates.1] -= 1000
                            explored[quadrantCoordinates.0][quadrantCoordinates.1] = galaxy[quadrantCoordinates.0][quadrantCoordinates.1]
                            if romulansRemaining == 0 {
                                messageEntries.append(MessageEntry(line: "*** ALL ROMULANS DESTROYED ***"))
                            } else {
                                messageEntries.append(MessageEntry(line: "*** ROMULANS REMAINING ELSEWHERE IN THE GALAXY ***"))
                            }
                        } else {
                            messageEntries.append(MessageEntry(line: "Sensors show \(romulans[romulanNumber][5]) units remaining."))
                        }
                        if romulansInQuadrant > 0 {romulansShootingAtEnterprise()}
                    }
                }
            }
        }
    }
}
