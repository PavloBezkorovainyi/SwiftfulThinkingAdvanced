//
//  AppTabBarView.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 07.10.2023.
//

import SwiftUI

struct AppTabBarView: View {
  
  @State private var selection: String = "home"
  @State private var tabSelection: TabBarItem = .home
  
  var body: some View {
    CustomTabBarContainerView(selection: $tabSelection) {
      Color.blue
        .tabBarItem(tab: .home, selection: $tabSelection)
      
      Color.red
        .tabBarItem(tab: .favorites, selection: $tabSelection)
      
      Color.green
        .tabBarItem(tab: .profile, selection: $tabSelection)
      
      Color.orange
        .tabBarItem(tab: .messages, selection: $tabSelection)
      
    }
  }
}

struct AppTabBarView_Previews: PreviewProvider {
  
  static var previews: some View {
    AppTabBarView()
  }
}

extension AppTabBarView {
  private var defaultTabView: some View {
    TabView(selection: $selection) {
      Color.red
        .tabItem {
          Image(systemName: "house")
          Text("Home")
        }
      Color.blue
        .tabItem {
          Image(systemName: "heart")
          Text("Favorites")
        }
      Color.orange
        .tabItem {
          Image(systemName: "house")
          Text("Profile")
        }
    }
  }
}
