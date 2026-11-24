extension Game {
    
    mutating func consumeEnergy() {
        if debug {print("consumeEnergy")}
        enterpriseEnergy -= enterpriseRequiredEnergy;  // a warp speed of 8 consumes 8x8+10 =74 energy, speed 1 instead 1x8+10 =18
        if(enterpriseEnergy >= 0) {
            return //EnergyLevel OK
        }
        messageEntries.append(MessageEntry(line: "Shield Control supplies energy to complete the manoeuvre."))
        enterpriseShields += enterpriseEnergy
        enterpriseEnergy = 0
        if enterpriseEnergy <= 0  {
            enterpriseEnergy = 0
        }
    }
    
}

