extension Game {
    
    mutating func printKlingonData () {
        if klingonsInQuadrant > 0 {
            print("Klingons in Quadrant \(klingonsInQuadrant)")
            for i in 1...3 {
                print("Klingon \(i) at Sector \(klingons[i][1]),\(klingons[i][2]) with \(klingons[i][3]) units of energy.")
            }
            displayBlankLine()
        } else {
            print("No Klingons in this Quadrant.")
        }
    }
}
