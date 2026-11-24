extension Game {
    mutating func estimateTimeToRepair() {
        if debug {print("estimateTimeToRepair()")}
        if enterpriseCondition == "DOCKED" {
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "Time needed for repairs being assessed. Starbase efficiency currently \(starbaseEfficiency)%."))
            enterpriseTotalDamage *= 1.00 + (100.00 - Double(starbaseEfficiency))/100.00
            enterpriseTotalDamage = Double(Int(enterpriseTotalDamage))
            messageEntries.append(MessageEntry(line: "Estimated time to repair damage as: \(String(format: "%.2f", enterpriseTotalDamage)) stardates."))
            if Int(enterpriseTotalDamage) >= missionDays {
                messageEntries.append(MessageEntry(line: "*** REPAIR TIME WILL USE UP ALL OF REMAINING MISSION ***"))
            }
        } else {
            if debug {print("Enterprise is not docked. Cannot perform repairs.")}
        }
    }
    
}
