extension Game {
    
    mutating func findEmptyPlaceinQuadrant() -> (Int,Int) {
        // generate 2 random coordinates, and check if quadrant cell is empty.
        //If empty space is found, returns the coordinates
        if debug {print("findEmptyPlaceinQuadrant()")}
        var found = false
        var row = 0
        var col = 0
        while (!found) {
            row = Int.random(in: 1...8)
            col = Int.random(in: 1...8)
            found = quadrant[row][col] == "   "
        }
        return (row, col)
    }
    
}
