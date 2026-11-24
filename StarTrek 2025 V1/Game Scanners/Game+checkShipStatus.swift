extension Game {
    
    mutating func checkShipStatus() -> String {
        if debug {print("checkShipStatus()")}
        switch true {
        case enterpriseDocked:
            return "DOCKED"
        case (klingonsInQuadrant != 0) || (romulansInQuadrant != 0):
            return "RED"
        case enterpriseEnergy < Constants.Game.originalEnergy / 10:
            return "YELLOW"
        default:
            return "GREEN"
        }
    }
    
}
