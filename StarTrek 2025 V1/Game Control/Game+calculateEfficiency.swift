extension Game {

    mutating func calculateEfficiency() {
        if debug {print("calculateEfficiency()")}
        
        // Variables
        let klingonsDestroyed = klingonsStarting - klingonsRemaining
        let totalDaysTaken = enterpriseStardate - missionStart
        //let originalDaysAllocated = missionDays  - missionStart
        if debug {
            print("Total Days Taken \(totalDaysTaken) Enterprise Stardate \(enterpriseStardate) Starting Stardate \(missionStart)")
            print("Klingons Destroyed \(klingonsDestroyed)")
            print("Total Days Taken \(totalDaysTaken)")
        }
        
        // Calculate percentage of Klingons destroyed
        let klingonPercentage = Double(klingonsDestroyed) / Double(klingonsStarting) * 100
        
        // Determine Klingon destruction efficiency
        var klingonEfficiency: String
        if klingonPercentage >= 90 {
            klingonEfficiency = "High Efficiency"
        } else if klingonPercentage >= 70 {
            klingonEfficiency = "Average Efficiency"
        } else {
            klingonEfficiency = "Low Efficiency"
        }
        
        // Calculate percentage of days taken
        let daysPercentage = Double(totalDaysTaken) / Double(missionDays) * 100
        
        // Determine time management efficiency
        var timeEfficiency: String
        if daysPercentage <= 100 {
            timeEfficiency = "High Efficiency"
        } else if daysPercentage <= 120 {
            timeEfficiency = "Average Efficiency"
        } else {
            timeEfficiency = "Low Efficiency"
        }
        
        // Calculate overall efficiency rating (you can adjust weights based on importance)
        let overallEfficiency = (klingonPercentage * 0.7) + (daysPercentage * 0.3)
        
        // Print or use the efficiency ratings
        displayBlankLine()
        messageEntries.append(MessageEntry(line: "Klingon Destruction Efficiency: \(klingonEfficiency)"))
        displayBlankLine()
        messageEntries.append(MessageEntry(line: "Time Management Efficiency: \(timeEfficiency)"))
        displayBlankLine()
        messageEntries.append(MessageEntry(line: "Overall Efficiency Rating: \(String(format: "%.2f", overallEfficiency))%"))
    }
}

