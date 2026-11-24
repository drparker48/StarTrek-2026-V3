extension Game {
    
    
    // MARK: Enemy Ship Functions
    
    mutating func klingonsShootingAtEnterprise () {
        if debug {print("klingonsShootingAtEnterprise()")}
        var klingonEnergy = 0.00
        var tempDamage = 0.00
        var hits = 0.00
        displayBlankLine()
        if enterpriseCondition == "DOCKED" {
            messageEntries.append(MessageEntry(line: "*** STARBASE SHIELDS PROTECT THE ENTERPRISE ***"))
        } else {
            for i in 1...klingonsInQuadrant {
                klingonEnergy = Double(klingons[i][3])
                if debug {print("Klingon Energy: \(klingonEnergy)")}
                if klingonEnergy > 0 {
                    hits = (klingonEnergy / distanceToShip(index: i)) // Hits based on distance to Enterprise
                    if debug {print("Hits = \(hits) based on klingonEnergy \(klingonEnergy) and distanceToShip \(distanceToShip(index: i))")}
                    hits = hits * (2.00 * Double.random(in: 0.00...1)) // Random factor affects damage by up to twice the calculated value
                    if debug {print("Hits after damage factor of up to twice = \(hits) based on klingonEnergy \(klingonEnergy) and distanceToShip \(distanceToShip(index: i))")}
                    if debug {print("Klingon Energy: \(klingonEnergy)")}
                    if Int(hits) > 0 {
                        messageEntries.append(MessageEntry(line: "Klingon firing . . ."))
                        klingons[i][3] = Int(klingonEnergy/(3 + Double.random(in: 0.00...0.99))) // K[I][3] = Int(KlingonEnergy/(3+Double.random(in:0.00...0.99)));
                        if debug {print("klingons[i][3]: \(klingons[i][3])")}
                        messageEntries.append(MessageEntry(line: "\(Int(hits)) unit hit on Enterprise from Klingon at Sector \(klingons[i][1]),\(klingons[i][2])"))
                        enterpriseShields = enterpriseShields - Int(hits)
                        if enterpriseShields < 0 {
                            messageEntries.append(MessageEntry(line: "*** ENTERPRISE DESTROYED - GAME OVER ****"))
                            enterpriseDestroyed = true
                            endGame(reason: "Destroyed")
                            missionOver = true
                        } else {
                            messageEntries.append(MessageEntry(line: "SHIELD CONTROL REPORTS: Shields down to \(enterpriseShields) units."))
                            //DAMAGE DUE TO KLINGON HITS
                            if hits > 19 && (enterpriseShields == 0 || (Int.random(in: 1...10) < 6 && (hits / Double(enterpriseShields)) > 0.02 )) {
                                let systemDamaged = Int.random(in: 1...9)
                                tempDamage = (hits / Double(enterpriseShields)) - 0.5 * Double.random(in: 0.00...1)
                                if debug {print("tempDamage: \(tempDamage)")}
                                if Int(tempDamage) <= 0 {enterpriseDamage[systemDamaged] = enterpriseDamage[systemDamaged] - 0.1}
                                else {if tempDamage > 1.0 { tempDamage = 0.9}
                                    enterpriseDamage[systemDamaged] = enterpriseDamage[systemDamaged] - tempDamage}
                                messageEntries.append(MessageEntry(line: "DAMAGE CONTROL REPORTS: \(enterpriseSystems[systemDamaged]) damaged by hit - now at \(enterpriseDamage[systemDamaged] * 100)%."))
                            } //DAMAGE DUE TO KLINGON HITS
                        }
                    } else {
                        messageEntries.append(MessageEntry(line: "Klingon at Sector \(klingons[i][1]),\(klingons[i][2]) firing missed the Enterprise."))
                    }
                }
            }
        }
    }
    
}

