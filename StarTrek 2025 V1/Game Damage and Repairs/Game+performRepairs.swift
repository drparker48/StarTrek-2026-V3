extension Game {
    
    mutating func performRepairs() {
        if debug {print("performRepairs()")}
        displayBlankLine()
        messageEntries.append(MessageEntry(line: "Repairs underway taking \(enterpriseTotalDamage) stardates."))
        enterpriseStardate += Int(enterpriseTotalDamage)
        missionDaysLeft -= Int(enterpriseTotalDamage)
        messageEntries.append(MessageEntry(line: "Mission will end in \(missionDaysLeft) stardates."))
        if missionDaysLeft <= 0 {
            endGame(reason: "Time")
            if debug {print("Enterprise Stardate: \(enterpriseStardate) Starting Stardate: \(missionStart) Days Left: \(missionDaysLeft)")}
            missionOver = true
        }
        for index in 0..<enterpriseDamage.count {
            enterpriseDamage[index] = 1.00
        }
        messageEntries.append(MessageEntry(line: "All systems are now functioning properly. Repairs completed."))
        getCommand()
    }
}
