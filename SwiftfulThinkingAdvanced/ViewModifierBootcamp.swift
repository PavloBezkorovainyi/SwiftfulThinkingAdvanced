//
//  ViewModifierBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 13.09.2023.
//

import SwiftUI

struct DefaultButtonViewModifier: ViewModifier {
  let backroundColor: Color
  
  func body(content: Content) -> some View {
    content
//    .font(.headline)
    .foregroundColor(.white)
    .frame(height: 55)
    .frame(maxWidth: .infinity)
    .background(backroundColor)
    .cornerRadius(10)
    .shadow(radius: 10)
//    .padding()
  }

  
  
}

struct ViewModifierBootcamp: View {
  var body: some View {
    VStack(spacing: 10) {
      Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        .withDefaultButtonFormatting()
        .font(.headline)
      
      Text("Hello, everyone!")
        .modifier(DefaultButtonViewModifier(backroundColor: .green))
      
      Text("Hello!!!")
        .withDefaultButtonFormatting(backgroundColor: .orange)
        .font(.title)
    }
    .padding()
  }
}

struct ViewModifierBootcamp_Previews: PreviewProvider {
  static var previews: some View {
    ViewModifierBootcamp()
  }
}

extension View {
  func withDefaultButtonFormatting(backgroundColor: Color = .blue) -> some View {
    modifier(DefaultButtonViewModifier(backroundColor: backgroundColor))
  }
}


