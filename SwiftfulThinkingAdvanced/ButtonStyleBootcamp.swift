//
//  ButtonStyleBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 13.09.2023.
//

import SwiftUI

struct PressableButtonStyle: ButtonStyle {
  
  let scaledAmount: CGFloat
  
  init(scaledAmount: CGFloat) {
    self.scaledAmount = scaledAmount
  }
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
      .opacity(configuration.isPressed ? 0.9 : 1)
    
    //      .brightness(configuration.isPressed ? 0.05 : 0)
  }
}

extension View {
  
  func withPressableStyle(scaledAmount: CGFloat = 0.9) -> some View {
    buttonStyle(PressableButtonStyle(scaledAmount: scaledAmount))
  }
}

struct ButtonStyleBootcamp: View {
  var body: some View {
    Button {
      
    } label: {
      Text("Click Me")
        .font(.headline)
        .withDefaultButtonFormatting()
    }
//    .buttonStyle(PressableButtonStyle())
    .withPressableStyle(scaledAmount: 1.1)
    .padding(40)
    
  }
}

struct ButtonStyleBootcamp_Previews: PreviewProvider {
  static var previews: some View {
    ButtonStyleBootcamp()
  }
}
