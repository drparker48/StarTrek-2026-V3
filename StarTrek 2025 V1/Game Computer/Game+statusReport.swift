extension Game {
    
    mutating func statusReport() {
        if debug {print("statusReport()")}
        var s = " remaining."
        displayBlankLine()
        messageEntries.append(MessageEntry(line: "STATUS REPORT:                                              "))
        displayBlankLine()
        if klingonsRemaining > 1 {s = "s remaining."}
        messageEntries.append(MessageEntry(line: "\(klingonsRemaining) Klingon\(s) "))
        if romulansRemaining > 0 {
            s = " remaining."
            if romulansRemaining > 1 {s = "s remaining."}
            messageEntries.append(MessageEntry(line: "\(romulansRemaining) Romulan\(s) "))
        }
        messageEntries.append(MessageEntry(line: "Mission must be completed in \(missionDaysLeft) Stardates."))
        messageEntries.append(MessageEntry(line: "You have \(enterpriseEnergy + enterpriseShields) units of energy and \(enterpriseTorpedoes) torpedoes left."))
        if starbasesRemaining < 1 {
            messageEntries.append(MessageEntry(line: "Your stupidity has left you on your own in the Galaxy."))
            messageEntries.append(MessageEntry(line: "You have no Starbases left!"))
        } else {
            if starbasesRemaining == 1 {
                s = ""
            } else {
                s = "s"
            }
            messageEntries.append(MessageEntry(line: "The Federation is maintaining \(starbasesRemaining) Starbase\(s) in the Galaxy."))
        }
        getCommand()
    }
    
}

