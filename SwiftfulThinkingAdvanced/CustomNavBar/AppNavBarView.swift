//
//  AppNavBarView.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 07.10.2023.
//

import SwiftUI
import NavigationBackport

struct AppNavBarView: View {
  var body: some View {
    CustomNavView {
      ZStack {
        Color.orange.ignoresSafeArea()
        
        CustomNavLink(destination:
                        Text("Destination")
                         .customNavigationTitle("Second Screen")
        ) {
          Text("Navigate")
          
        }
        
      }
      .customNavigationTitle("Custom")
      .customNavigationBarBackButtonHidden(true)
    }
  }
}

struct AppNavBarView_Previews: PreviewProvider {
  static var previews: some View {
    AppNavBarView()
  }
}

extension AppNavBarView {
  var defaultNavView: some View {
    NBNavigationStack {
      ZStack {
        Color.green.ignoresSafeArea()
        
        NavigationLink {
          Text("Destination")
            .navigationTitle("Title 2")
            .navigationBarBackButtonHidden(false)
        } label: {
          Text("Navigate")
        }
        
      }
      .navigationTitle("Nav title here")
    }
  }
}
