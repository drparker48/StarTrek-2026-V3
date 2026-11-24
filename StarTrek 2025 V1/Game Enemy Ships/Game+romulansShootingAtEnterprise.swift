extension Game {
    mutating func romulansShootingAtEnterprise () {
        if debug {print("romulansShootingAtEnterprise()")}
        var romulanEnergy = 0.00
        var tempDamage = 0.00
        var hits = 0.00
        displayBlankLine()
        messageEntries.append(MessageEntry(line: "*** ROMULAN BIRD OF PREY DECLOAKING ****"))
        romulanCloaked = false
        if enterpriseCondition == "DOCKED" {
            messageEntries.append(MessageEntry(line: "*** STARBASE SHIELDS PROTECT THE ENTERPRISE ***"))
        } else {
            romulanEnergy = Double(romulans[romulanNumber][5])
            if romulanEnergy > 0 {
                hits = (romulanEnergy / distanceToShip(index: romulanNumber)) // Hits based on distance to Enterprise
                if debug {print("Hits = \(hits) based on romulanEnergy \(romulanEnergy) and distanceToShip \(distanceToShip(index: romulanNumber))")}
                hits = hits * (2.00 * Double.random(in: 0.00...1)) // Random factor affects damage by up to twice the calculated value
                // If hits <= 0, then the Romulan ship is out of energy and will not fire
                if debug {print("Hits after damage factor of up to twice = \(hits) based on romulanEnergy \(romulanEnergy) and distanceToShip \(distanceToShip(index: romulanNumber))")}
                enterpriseShields = enterpriseShields - Int(hits)
                romulans[romulanNumber][5] -= Int(hits)
                messageEntries.append(MessageEntry(line: "\(Int(hits)) unit hit on Enterprise from Romulan Warbird at Sector \(romulans[romulanNumber][2]),\(romulans[romulanNumber][3])"))
                if enterpriseShields < 0 {
                    messageEntries.append(MessageEntry(line: "*** ENTERPRISE DESTROYED BY ROMULAN BIRD OF PREY - GAME OVER ****"))
                    enterpriseDestroyed = true
                    endGame(reason: "Destroyed")
                    missionOver = true
                } else {
                    messageEntries.append(MessageEntry(line: "SHIELD CONTROL REPORTS: Shields down to \(enterpriseShields) units."))
                    
                    //DAMAGE DUE TO ROMULAN HITS
                    if hits > 19 && (enterpriseShields == 0 || (Int.random(in: 1...10) < 6 && (hits / Double(enterpriseShields)) > 0.02 )) {
                        let systemDamaged = Int.random(in: 1...9)
                        tempDamage = (hits / Double(enterpriseShields)) - 0.5 * Double.random(in: 0.00...1)
                        if debug {print("tempDamage: \(tempDamage)")}
                        if Int(tempDamage) <= 0 {enterpriseDamage[systemDamaged] = enterpriseDamage[systemDamaged] - 0.1}
                        else {if tempDamage > 1.0 { tempDamage = 0.9}
                            enterpriseDamage[systemDamaged] = enterpriseDamage[systemDamaged] - tempDamage}
                        messageEntries.append(MessageEntry(line: "DAMAGE CONTROL REPORTS: \(enterpriseSystems[systemDamaged]) damaged by hit - now at \(enterpriseDamage[systemDamaged] * 100)%."))
                    } //DAMAGE DUE TO ROMULAN HITS
                }
            }
        }
    }
}
