extension Game {
    
    // MARK: Damage and Repair Functions
    
    mutating func damageControl() {
        if debug { print("damageControl()") }
        // Display Damage Report
        enterpriseTotalDamage = 0.0
        displayBlankLine()
        messageEntries.append(MessageEntry(line: "DAMAGE REPORT:"))
        enterpriseSystemsDamaged = false
        for i in 1...9 {
            if enterpriseDamage[i] < 1.0 {
                enterpriseSystemsDamaged = true
                let temp = Int(enterpriseDamage[i] * 100)
                enterpriseTotalDamage += abs(enterpriseDamage[i])
                if debug {print("Enterprise Damage[\(i)] = \(enterpriseDamage[i])")}
                if debug {print("Total Enterprise Damage = \(enterpriseTotalDamage)")}
                var myString = "             " + enterpriseSystems[i]
                myString = myString.padding(toLength: 35, withPad: " ", startingAt: 0)
                myString = myString + String(temp) + "% efficient."
                myString = myString.padding(toLength: 60, withPad: " ", startingAt: 0)
                messageEntries.append(MessageEntry(line: String(myString)))
            }
        }
        if enterpriseSystemsDamaged {
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "Total repairs needed \(String(format: "%.2f", enterpriseTotalDamage)) stardates depending on Starbase efficiency."))
            // If docked and Enterprise damaged then ask for repairs to be authorised
            if enterpriseCondition == "DOCKED" && starbaseCondition != 2 {
                estimateTimeToRepair()
            }
        } else {
            messageEntries.append(MessageEntry(line: "All systems are functioning properly. No repairs needed."))
        }
        getCommand()
    }
}
