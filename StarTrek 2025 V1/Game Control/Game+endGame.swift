extension Game {
    
    mutating func endGame(reason: String) {
        var wasWhere = "were"
        var cruisers = "cruisers"
        if debug {print("endGame() - \(reason)")}
        missionOver = true
        displayBlankLine()
        // Announce Stardate and deal with each reason
        messageEntries.append(MessageEntry(line: "It is Stardate \(enterpriseStardate)."))
        switch reason {
            
        case "Destroyed" : // Enterprise destroyed
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "The USS Enterprise has been destroyed."))
            calculateEfficiency()
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "Press New Mission if you wish to try again."))
            missionStarted = false
            missionOver = true
            
        case "Starbase" : // Last Starbase destroyed by Enterprise or enemy ship
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "The last Starbase in the galaxy has been destroyed."))
            messageEntries.append(MessageEntry(line: "That does it, Captain! You are hearby relieved of command and sentenced to 99 Stardates of hard labour at Cygnus 12!!"))
            calculateEfficiency()
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "When you have completed your sentence you can press New Mission to try again."))
            missionStarted = false
            missionOver = true
            
        case "Resigned" : // Resigned command
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "You have resigned your command."))
            displayBlankLine()
            if klingonsRemaining < 2 {
                wasWhere = "was"
                cruisers = "cruiser"
            }
            messageEntries.append(MessageEntry(line: "There \(wasWhere) \(klingonsRemaining) Klingon battle \(cruisers) left at the end of your mission."))
            calculateEfficiency()
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "Press New Mission if you wish to try again."))
            missionStarted = false
            missionOver = true
            
        case "Halted" : // Halted mission
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "You have halted the mission."))
            calculateEfficiency()
            missionOver = false
            getCommand()
            
        case "Time" : // Run out of time
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "You have run out of time."))
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "There were \(klingonsRemaining) Klingon battle cruisers left at the end of your mission."))
            calculateEfficiency()
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "Press New Mission if you wish to try again."))
            missionStarted = false
            missionOver = true
            
        case "Success" : // Destroyed all Klingon ships
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "Congratulations, Captain! The last Klingon battle cruiser menacing the Federation has been destroyed."))
            calculateEfficiency()
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "The Federation is in need of a new Starship Commander for a similar mission. If you wish to volunteer press New Mission."))
            missionStarted = false
            missionOver = true
            
        default : // Some ther reason
            displayBlankLine()
            messageEntries.append(MessageEntry(line: "Some other reason???"))
            calculateEfficiency()
        }
    }
    
}

