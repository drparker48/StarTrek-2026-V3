extension Game {
    
    // MARK: Utility Functions
    
    mutating func damageSystems() {
        if debug {print("damageSystems()")}
        enterpriseDamage[Constants.SystemNumber.longRangeSensors] = 0.8
        enterpriseDamage[Constants.SystemNumber.photonTubes] = 0.8
        enterpriseDamage[Constants.SystemNumber.phaserControl] = 0.8
    }
}
