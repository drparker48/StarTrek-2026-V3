//
//  SplashView.swift
//  SuperStarTrek
//
//  Created by David Parker on 23/03/2024.
//

import SwiftUI

struct SplashView: View {
    @State private var isSplashFinished = false
    var body: some View {
        ZStack {
            Image("StarTrekEmblem")
                .resizable()
            
            VStack {
                HStack{
                    Text("SUPER")
                        .font(Font.custom("Roddenberry", size: 60.0))
                        .foregroundColor(Color.black)
                        .padding()
                    Spacer()
                    Text("DAVID'S")
                        .font(Font.custom("Roddenberry", size: 60.0))
                        .foregroundColor(Color.black)
                        .padding()
                }
                HStack{
                    Text("STAR")
                        .font(Font.custom("Roddenberry", size: 60.0))
                        .foregroundColor(Color.black)
                        .padding()
                    Spacer()
                    Text("RETRO")
                        .font(Font.custom("Roddenberry", size: 60.0))
                        .foregroundColor(Color.black)
                        .padding()
                }
                HStack{
                    Text("TREK")
                        .font(Font.custom("Roddenberry", size: 60.0))
                        .foregroundColor(Color.black)
                        .padding()
                    Spacer()
                    Text("PROGRAMS")
                        .font(Font.custom("Roddenberry", size: 60.0))
                        .foregroundColor(Color.black)
                        .padding()
                }
                Spacer()
                Text("Version 2026 V3")
                    .font(Font.custom("Roddenberry", size: 60.0))
                    .foregroundColor(Color.black)
                    .padding()
            }
        }
        .onAppear {
            // Perform any necessary tasks here
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                // Simulating asynchronous task completion after 5 seconds
                self.isSplashFinished = true
            }
        }
        .fullScreenCover(isPresented: $isSplashFinished) {
            ContentView()
        }
        
    }
}

#Preview {
    SplashView()
}
