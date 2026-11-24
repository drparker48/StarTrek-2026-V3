//
//  Game.swift
//  SuperStarTrek
//
//  Created by David Parker on 15/02/2023.
//

import Foundation
import SwiftUI
import AVFoundation

// Galaxy
var eQuadrantName = "" //G2$
let gQuadrantNames = [["Antares","Rigel","Procyon","Vega","Canopus","Altair","Sagittarius","Pollux"], ["Sirius","Deneb","Capella","Betelgeuse","Aldebaran","Regulus","Arcturus","Spica"]] //Not stored in original BASIC program
let gSectorNames = [" I"," II"," III"," IV"] //Not stored in original BASIC program

struct MessageEntry: Equatable, Identifiable {
    let line: String
    var id = UUID()
}

struct Game {
    
    // MARK: Variables
    
    // Global
    let condition = ["GREEN","YELLOW","RED"]
    
    var debug = false //To cause debug messages to be printed to the console
    
    // Enterprise
    var enterpriseRequiredEnergy = 0 //N
    var enterpriseCondition = "GREEN" //C$
    var enterpriseDamage = Array(repeating: 1.00, count: 10) //Set operating efficiency at 1.00 (equivalent to 100%) for each of 9 systems = D(9)
    var enterpriseDocked = false // D0 docked flag (set to 0 = false at start) to indicate whether Enterprise is docked or not
    var enterpriseTotalDamage = 0.0
    var enterpriseDestroyed: Bool = false // Flag to indicate Enterprise has been destroyed
    var enterpriseEnergy = Constants.Game.originalEnergy //E initial energy = 3000
    var enterpriseShields = 0 //S shields
    var enterpriseStardate = Constants.Game.originalStardate + Int.random(in:1...20) * 100//T current stardate from 2,000 to 4,000
    var enterpriseSystemsDamaged = false
    var enterpriseTorpedoes = Constants.Game.originalTorpedoes //P number of torpedoes
    let enterpriseSystems = ["EMPTY","Impulse Engines","Warp Engines","Short Range Sensors","Long Range Sensors","Phaser Control","Photon Tubes","Damage Control","Shield Control","Library Computer"]
    var explored = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9) //Z() discovered galaxy
    
    // Mission
    var missionDaysLeft: Int = 25 + Int.random(in:1...10) //T9 Set to 25 + Int.random(in:1...10)
    var missionOver = false
    var missionStarted = false
    var missionDays = 0
    var missionStart = 0
    
    // Galaxy
    var galaxy = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9) //G() undiscovered galaxy
    var lrs = [0,0,0,0,0,0,0,0,0] //Used in building Long Range ", Galactic Record
    var quadrant = Array(repeating: Array(repeating: "   ", count: 9), count: 9)//Q$
    var quadrantCoordinates = (0,0)
    var sectorCoordinates = (0,0)
    var starsInQuadrant = 0
    
    // Klingons
    var klingons = [[Int]](repeating: [Int](repeating: 0, count: 4), count: 4) //K() klingon data for current quadrant
    var klingonsInQuadrant = 0
    var klingonsRemaining = 0 //K9 klingons
    var klingonsStarting = 0 //K7
    
    // Main Screen
    var messageEntries: [MessageEntry] = [] //Stores output screen
    
    // Romulans
    var romulans = [[Int]](repeating: [Int](repeating: 0, count: 6), count: 4) //Romulan data for galaxy
    // [0] and [1] quadrant coordinates [2] and [3] sector coordinates [4] cloaked 0 = false 1 = true [5] energy 0-400
    var romulansInQuadrant = 0
    var romulansRemaining = 0
    var romulansStarting = 0
    var romulanNumber = 0 //Romulan vessel number
    var romulanCloaked = true // cloaked flag (set to true at start) to indicate whether Romulan is cloaked or not
    
    // Starbases
    var starbase = Array(repeating: Array(repeating: 0, count: 6), count: 7)
    // [0] = quadrantRow (1-8), [1] = quadrantCol (1-8), [2] = condition (1-3), [3] = efficiency (0-100), [4] = energy, [5] = torpedoes
    var starbasesRemaining = 0 //B9 starbases
    var starbasesInQuadrant = 0 // TO DO: Change to Boolean
    var starbaseCondition =  0
    var starbaseDestroyed = false
    var starbaseEfficiency = 0
    var starbaseEnergy = 0
    var starbaseNumber = 1
    var starbaseRepairPossible = true
    var starbaseSupplyPossible = true
    var starbaseTorpedoes = 0
    var starbaseSectorCoordinates = (0,0)
    var starbaseUnderAttack = false
    
    // Damage and repairs
    var damageFactor = 0.00
    var damageRepairTime = 0
    var damageRepairFactor = 1 // Multiply with Starbase repair efficiency
    var damageRepairTotal = 0.0
    
    // Various
    var temp = 0
    var temp$ = "" //Used in building Long Range ", Galactic Record
    
    struct SoundEffects {
        func playSoundEffect(fileName: String) {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else { return }
            
            do {
                let sound = try AVAudioPlayer(contentsOf: url)
                sound.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
        
        // Call the function to play a specific sound effect
        //playSoundEffect(fileName: "starTrekPhotonTorpedo")
    }
}

