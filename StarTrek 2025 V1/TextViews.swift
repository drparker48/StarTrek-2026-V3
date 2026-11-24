xxxxxx//
//  TextViews.swift
//  SuperStarTrek
//
//  Created by David Parker on 14/02/2023.
//

import SwiftUI

struct TextViews: View {
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    .font(Font.custom("Roddenberry", size: 40.0))
  }
}

struct MessageText: View {
  let text: String
  var body: some View {
    Text(text)
      .font(.system(size: 25, design: .monospaced))
      .kerning(3.0)
      .foregroundStyle(.green) // Adjust the text color as needed  iOS 17 and later
      .fontWeight(.black)
      
  }
}

struct CommandText: View {
    var text: String
    var body: some View {
        Text(text)
            .bold()
            //.font(.body)
            .font(Font.custom("Roddenberry", size: 20.0))
            .multilineTextAlignment(.center)
            .frame(maxWidth: 120, maxHeight: 60) // Reduced frame height to give more space for messages
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.8), Color.accentColor.opacity(0.5)]), startPoint: .top, endPoint: .bottom) // Adding gradient for a 3D effect
            )
            //.background(Color.accentColor)//Background colour changes depending on type of control
            .foregroundStyle(.white) // Adjust the text color as needed  iOS 17 and later
            .cornerRadius(12.0)
            .shadow(color: Color.black.opacity(0.7), radius: 5, x: 2, y: 2) // Adding a shadow effect for depth
            .overlay(
                RoundedRectangle(cornerRadius: 12.0)
                    .stroke(Color.white.opacity(0.5), lineWidth: 2) // Adding a border for highlight effect
            )
    }
}

struct AlertMessageText: View {
  let text: String
  var body: some View {
    Text(text)
      .multilineTextAlignment(.leading)
  }
}

#Preview {
    VStack {
      TextViews()
      CommandText(text: "Command")
      MessageText(text: "Message")
      AlertMessageText(text: "Alert")
    }
}
