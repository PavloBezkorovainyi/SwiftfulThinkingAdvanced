//
//  CustomNavLink.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 07.10.2023.
//

import SwiftUI

struct CustomNavLink<Label: View, Destination: View>: View {
  
  let destination: Destination
  let label: Label
  
  init(destination: Destination, @ViewBuilder label: () -> Label) {
    self.destination = destination
    self.label = label()
  }
  
  var body: some View {
    NavigationLink(
      destination:
        CustomNavBarContainerView(content: {
          destination
        })
        .navigationBarHidden(true)
        ,
      label: {
        label
      })
  }
}

struct CustomNavLink_Previews: PreviewProvider {
  static var previews: some View {
    CustomNavView {
      CustomNavLink(
        destination: Text("Destination")) {
          Text("CLICK ME")
        }
    }
  }
}
