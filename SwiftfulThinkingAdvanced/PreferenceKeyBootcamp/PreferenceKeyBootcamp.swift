//
//  PreferenceKeyBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 04.10.2023.
//

import SwiftUI

struct PreferenceKeyBootcamp: View {
  
  @State private var text: String = "Hello, world!"
  
  var body: some View {
    NavigationStack {
      VStack {
        SecondaryScreen(text: text)
          .navigationTitle("Navigation Title")
      }
    }
    .onPreferenceChange(CustomTitlePreferenceKey.self) { value in
      self.text = value
    }
  }
}

extension View {
  
  func customTitle(_ text: String) -> some View {
    self.preference(key: CustomTitlePreferenceKey.self, value: text)
  }
}

struct PreferenceKeyBootcamp_Previews: PreviewProvider {
  static var previews: some View {
    PreferenceKeyBootcamp()
  }
}

struct SecondaryScreen: View {
  let text: String
  @State private var newValue: String = ""
  
  var body: some View {
    Text(text)
      .onAppear(perform: getDataFromDatabase)
      .customTitle(newValue)
  }
  
  func getDataFromDatabase() {
    //download
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.newValue = "NEW VALUE FROM DATA BASE"
    }
    
  }
}

struct CustomTitlePreferenceKey: PreferenceKey {
  typealias Value = String
  static var defaultValue: Value = ""
  
  static func reduce(value: inout String, nextValue: () -> String) {
    value = nextValue()
  }
}
