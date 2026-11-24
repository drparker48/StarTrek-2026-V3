extension Game {
    
    mutating func locateStarbase(quadrantCoordinates: (row: Int, col: Int)) {
        if debug {print("locateStarbase()")}
        for i in 1...starbasesRemaining {
            if quadrantCoordinates.row == starbase[i][0] && quadrantCoordinates.col == starbase[i][1] {
                starbaseCondition = starbase[i][2]
                starbaseEnergy = starbase[i][4]
                starbaseTorpedoes = starbase[i][5]
                starbaseEfficiency = starbase[i][3]
                starbaseNumber = i
            }
        }
    }
    
}

