//
//  ContentView.swift
//  StarTrekV08
//
//  Created by David Parker on 04/05/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var gameState = Game()

    var body: some View {
      
        ZStack {
            // Background Color
            Color("BackgroundColour")
                .edgesIgnoringSafeArea(.all)
            
            // Main Screen View
            MainScreenView(game: $gameState)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light Color Scheme Preview
            ContentView()
                .previewInterfaceOrientation(.landscapeLeft)
                .preferredColorScheme(.light)
            
            // Dark Color Scheme Preview
            ContentView()
                .previewInterfaceOrientation(.landscapeLeft)
                .preferredColorScheme(.dark)
        }
    }
}
