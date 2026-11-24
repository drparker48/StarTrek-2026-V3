extension Game {
    
    mutating func distanceToShip (index: Int) -> Double {
        if debug {print("distanceToShip()")}
        let dx = Double(klingons[index][1]) - Double(sectorCoordinates.0)
        let dy = Double(klingons[index][2]) - Double(sectorCoordinates.1)
        return ((dx * dx) + (dy * dy)).squareRoot()
    }
}
