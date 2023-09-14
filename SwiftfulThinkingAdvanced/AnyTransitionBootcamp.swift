//
//  AnyTransitionBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 13.09.2023.
//

import SwiftUI

struct RotateViewModifier: ViewModifier {
  
  let rotation: Double
  
  func body(content: Content) -> some View {
    content
      .rotationEffect(Angle(degrees: rotation))
      .offset(
        x: rotation != 0 ? UIScreen.main.bounds.width : 0,
        y: rotation != 0 ? UIScreen.main.bounds.height : 0
      )
  }
}

extension AnyTransition {
  static var rotating: AnyTransition {
    modifier(
      active: RotateViewModifier(rotation: 180),
      identity: RotateViewModifier(rotation: 0)
    )
  }
  
  static func rotating(rotation: Double) -> AnyTransition {
    modifier(
      active: RotateViewModifier(rotation: rotation),
      identity: RotateViewModifier(rotation: 0)
    )
  }
  
  static var rotateOn: AnyTransition {
     asymmetric(
      insertion: .rotating,
      removal: .move(edge: .leading)
     )
  }
}

struct AnyTransitionBootcamp: View {
  @State private var showRectangle: Bool = false
  
  var body: some View {
    VStack {
      Spacer()
      
      if showRectangle {
        RoundedRectangle(cornerRadius: 25)
          .frame(width: 250, height: 350)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .transition(.rotateOn)
//          .transition(.asymmetric(insertion: <#T##AnyTransition#>, removal: <#T##AnyTransition#>))
//          .transition(.rotating(rotation: 1080))
        //            .transition(.move(edge: .leading))
      }
      
      Spacer()
      
      Text("Click me!")
        .withDefaultButtonFormatting()
        .padding(.horizontal, 40)
        .onTapGesture {
          withAnimation(.easeInOut) {
            showRectangle.toggle()
          }
        }
    }
  }
}

struct AnyTransitionBootcamp_Previews: PreviewProvider {
  static var previews: some View {
    AnyTransitionBootcamp()
  }
}
