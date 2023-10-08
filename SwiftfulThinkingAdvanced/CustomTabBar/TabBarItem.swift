//
//  TabBarItem.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 07.10.2023.
//

import SwiftUI

enum TabBarItem: Hashable {
  case home, favorites, profile, messages
  
  var iconName: String {
    switch self {
    case .home: return "house"
    case .favorites: return "heart"
    case .profile: return "person"
    case .messages: return "message"
    }
  }
  
  var title: String {
    switch self {
    case .home: return "Home"
    case .favorites: return "Favorites"
    case .profile: return "Profile"
    case .messages: return "Message"
    }
  }
  
  var color: Color {
    switch self {
    case .home: return .red
    case .favorites: return .blue
    case .profile: return .green
    case .messages: return .orange
    }
  }
}
