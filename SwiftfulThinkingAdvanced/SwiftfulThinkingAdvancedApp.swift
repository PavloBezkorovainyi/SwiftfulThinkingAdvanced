//
//  SwiftfulThinkingAdvancedApp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 13.09.2023.
//

import SwiftUI

@main
struct SwiftfulThinkingAdvancedApp: App {
  
  let currentUserIsSignedIn: Bool
  
  init() {
//    let userIsSignedIn: Bool = CommandLine.arguments.contains("-UITest_startSignedIn")
    let userIsSignedIn = ProcessInfo.processInfo.arguments.contains("-UITest_startSignedIn")
//    let value = ProcessInfo.processInfo.environment["-UITest_startSignedIn2"]
    self.currentUserIsSignedIn = userIsSignedIn
  }
  
  var body: some Scene {
    WindowGroup {
      UITestingBootcampView(currentUserIsSignedIn: currentUserIsSignedIn)
    }
  }
}
