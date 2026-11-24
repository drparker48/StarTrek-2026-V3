extension Game {
    // MARK: Navigation Functions
    
    mutating func calculateDistance(from point1: (Int, Int), to point2: (Int, Int)) -> Int {
        //Calculate the distance between two points on an 8 by 8 grid
        if debug {print("calculateDistance()")}
        let deltaX = abs(point2.0 - point1.0)
        let deltaY = abs(point2.1 - point1.1)
        return max(deltaX, deltaY)
    }
    
}

