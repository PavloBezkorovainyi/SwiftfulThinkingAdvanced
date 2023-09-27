//
//  AnimationDataBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 24.09.2023.
//

import SwiftUI

struct AnimationDataBootcamp: View {
  
  @State private var animate: Bool = false
  
  var body: some View {
    ZStack {
//      RoundedRectangle(cornerRadius: animate ? 60 : 0)
      RectangleWithSingleCornerAnimation()
        .frame(width: 250, height: 250)
    }
    .onAppear() {
      withAnimation(.linear(duration: 2.0).repeatForever()) {
        animate.toggle()
      }
    }
  }
}

struct AnimationDataBootcamp_Previews: PreviewProvider {
  static var previews: some View {
    AnimationDataBootcamp()
  }
}

struct RectangleWithSingleCornerAnimation: Shape {
  
  var cornerRadius: CGFloat = 60
  
  var animatableData: CGFloat {
    get { cornerRadius }
    set { cornerRadius = newValue }
  }
  
  func path(in rect: CGRect) -> Path {
    Path { path in
      path.move(to: .zero)
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
      
      path.addArc(
        center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
        radius: cornerRadius,
        startAngle: Angle(degrees: 0),
        endAngle: Angle(degrees: 90),
        clockwise: false)
      
      path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    }
  }
}
