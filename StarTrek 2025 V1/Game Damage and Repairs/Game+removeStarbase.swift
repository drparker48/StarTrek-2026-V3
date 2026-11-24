extension Game {
    
    
    mutating func removeStarbase(starbaseCoordinates: (row: Int, col: Int)) {
        if debug {print("removeStarbase()")}
        for i in 1...starbasesRemaining {
            if starbaseCoordinates.row == starbase[i][1] && starbaseCoordinates.col == starbase[i][1] {starbase[i].remove(at: i)}
        }
    }
    
}

