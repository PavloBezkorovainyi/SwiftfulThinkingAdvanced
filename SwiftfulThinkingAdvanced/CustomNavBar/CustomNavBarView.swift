//
//  CustomNavBarView.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 07.10.2023.
//

import SwiftUI

struct CustomNavBarView: View {
  @Environment(\.presentationMode) var presentationMode
  let showBackButton: Bool
  let title: String
  let subtitle: String?
  
  var body: some View {
    HStack {
      if showBackButton {
        backbutton
      }
      Spacer()
      titleSecion
      Spacer()
      if showBackButton {
        backbutton
          .opacity(0)
      }
    }
    .padding()
    .accentColor(.white)
    .foregroundColor(.white)
    .font(.headline)
    .background(
      Color.blue.ignoresSafeArea(edges: .top)
    )
  }
}

struct CustomNavBarView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      CustomNavBarView(showBackButton: true, title: "Title here", subtitle: "Subtitle here")
      Spacer()
    }
  }
}


extension CustomNavBarView {
  
  private var backbutton: some View {
    Button {
      presentationMode.wrappedValue.dismiss()
    } label: {
      Image(systemName: "chevron.left")
    }
  }
  
  private var titleSecion: some View {
    VStack(spacing: 4) {
      Text(title)
        .font(.title)
        .fontWeight(.semibold)
      if let subtitle {
        Text(subtitle)
      }
    }
  }
}
