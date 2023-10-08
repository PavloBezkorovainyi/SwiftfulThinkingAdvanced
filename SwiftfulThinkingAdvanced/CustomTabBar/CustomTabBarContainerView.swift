//
//  CustomTabBarContainerView.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 07.10.2023.
//

import SwiftUI

struct CustomTabBarContainerView<Content: View>: View {
  
  @Binding var selection: TabBarItem
  let content: Content
  @State private var tabs: [TabBarItem] = []
  
  init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
    self._selection = selection
    self.content = content()
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      content
        .ignoresSafeArea()
      
      VStack {
        Spacer()
        CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection)
        //customize this for height
        Rectangle()
          .fill(Color.clear)
          .frame(height: 20)
          .frame(maxWidth: .infinity)
      }
     
    }
    .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
      self.tabs = value
    }
  }
}

struct CustomTabBarContainerView_Previews: PreviewProvider {
  
  static let tabs: [TabBarItem] = [
    .home, .favorites, .profile
  ]
  
  static var previews: some View {
    CustomTabBarContainerView(selection: .constant(tabs.first!)) {
      Color.red
    }
  }
}
