extension Game {
    
    mutating func checkIfDocked() {
        // Limit to checking if Enterprise is docked and identifying Starbase
        if debug {print("checkIfDocked()")}
        var energyRequired = 0
        var torpedoesRequired = 0
        
        // Check if Enterprise is in next Sector to Starbase
        enterpriseDocked = false
        for i in sectorCoordinates.0 - 1...sectorCoordinates.0 + 1 {
            for j in sectorCoordinates.1 - 1...sectorCoordinates.1 + 1 {
                let ii = i
                let jj = j
                if (ii >= 1 && ii <= 8 && jj >= 1 && jj <= 8) {
                    if quadrant[i][j] == ">!<" {
                        enterpriseDocked = true
                        enterpriseCondition = "DOCKED"
                        starbaseRepairPossible = true
                        
                        // Determine which Starbase docked at
                        locateStarbase(quadrantCoordinates: quadrantCoordinates)
                        
                        // Display Starbase location, energy and torpedo reserves and repair efficiency
                        // Starbase sector coordinates come from enterNewQuadrant
                        messageEntries.append(MessageEntry(line: "Enterprise docked at Starbase in Sector \(starbaseSectorCoordinates.0),\(starbaseSectorCoordinates.1)."))
                        
                        // Return Shield energy to main banks
                        enterpriseEnergy += enterpriseShields
                        enterpriseShields = 0
                        messageEntries.append(MessageEntry(line: "*** SHIELDS DROPPED FOR DOCKING - RAISE BEFORE UNDOCKING ***"))
                        enterpriseCondition = checkShipStatus()
                        
                        // Determine what action can be taken depending on Starbase condition
                        switch starbaseCondition {
                        case 2: // RED under attack so no repairs or supply
                            starbaseRepairPossible = false
                            starbaseSupplyPossible = false
                            if debug {print("enterpriseSystemsDamaged = \(enterpriseSystemsDamaged) enterpriseDocked = \(enterpriseDocked) starbaseRepairPossible = \(starbaseRepairPossible)")}
                            messageEntries.append(MessageEntry(line: "Starbase Alert Condition RED under attack. No repair or supply possible."))
                            getCommand()
                            
                        case 1: // YELLOW Starbase under repair after attack has limited repair ability but can supply
                            starbaseRepairPossible = true
                            damageRepairFactor = starbaseEfficiency / 2
                            starbaseSupplyPossible = true
                            if debug {print("enterpriseSystemsDamaged = \(enterpriseSystemsDamaged) enterpriseDocked = \(enterpriseDocked) starbaseRepairPossible = \(starbaseRepairPossible)")}
                            messageEntries.append(MessageEntry(line: "Starbase Alert Condition YELLOW repairs underway following attack. Limited repairs possible but can supply."))
                            // Check if Starbase has enough energy and torpedoes to resupply. Reduce Starbase reserves and resupply Enterprise
                            energyRequired = 3000 - enterpriseEnergy
                            if energyRequired > 0  {
                                messageEntries.append(MessageEntry(line: "Energy required = \(energyRequired)."))
                                starbaseEnergy -= energyRequired
                                starbase[starbaseNumber][4] = starbaseEnergy
                                messageEntries.append(MessageEntry(line: "Starbase energy reserves reduced to \(starbaseEnergy)"))
                                enterpriseEnergy = 3000
                            }
                            torpedoesRequired = 10 - enterpriseTorpedoes
                            if torpedoesRequired > 0 {
                                messageEntries.append(MessageEntry(line: "Photon Torpedoes required = \(torpedoesRequired)."))
                                starbaseTorpedoes -= torpedoesRequired
                                starbase[starbaseNumber][5] = starbaseTorpedoes
                                messageEntries.append(MessageEntry(line: "Starbase Torpedo reserves reduced to \(starbaseTorpedoes)"))
                                enterpriseTorpedoes = 10
                            }
                            messageEntries.append(MessageEntry(line: "Energy levels and Photon Torpedoes replenished where required."))
                            getCommand()
                            
                        case 0: // GREEN Repairs and supply possible
                            starbaseRepairPossible = true
                            damageRepairFactor = starbaseEfficiency
                            starbaseSupplyPossible = true
                            if debug {print("enterpriseSystemsDamaged = \(enterpriseSystemsDamaged) enterpriseDocked = \(enterpriseDocked) starbaseRepairPossible = \(starbaseRepairPossible)")}
                            messageEntries.append(MessageEntry(line: "Starbase Alert Condition GREEN repairs and supply possible."))
                            
                            // Check if Starbase has enough energy and torpedoes to resupply. Reduce Starbase reserves and resupply Enterprise
                            energyRequired = 3000 - enterpriseEnergy
                            if energyRequired > 0  {
                                messageEntries.append(MessageEntry(line: "Energy required = \(energyRequired)."))
                                starbaseEnergy -= energyRequired
                                starbase[starbaseNumber][4] = starbaseEnergy
                                messageEntries.append(MessageEntry(line: "Starbase energy reserves reduced to \(starbaseEnergy)"))
                                enterpriseEnergy = 3000
                            }
                            torpedoesRequired = 10 - enterpriseTorpedoes
                            if torpedoesRequired > 0 {
                                messageEntries.append(MessageEntry(line: "Photon Torpedoes required = \(torpedoesRequired)."))
                                starbaseTorpedoes -= torpedoesRequired
                                starbase[starbaseNumber][5] = starbaseTorpedoes
                                messageEntries.append(MessageEntry(line: "Starbase Torpedo reserves reduced to \(starbaseTorpedoes)"))
                                enterpriseTorpedoes = 10
                            }
                            messageEntries.append(MessageEntry(line: "Energy levels and Photon Torpedoes replenished as required."))
                            // Determine if repairs are needed and how long they will take
                            // Either report no repairs needed or name systems that require repairs
                            // Estimate time for repairs taking efficiency into account
                            // Accept or decline repairs
                            getCommand()
                            
                        default:
                            messageEntries.append(MessageEntry(line: "Starbase Alert Condition UNKNOWN."))
                        }
                    }
                }
            }
        }
    }
    
}

