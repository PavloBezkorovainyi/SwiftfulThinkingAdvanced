//
//  CustomNavView.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 07.10.2023.
//

import SwiftUI
import NavigationBackport

struct CustomNavView<Content: View>: View {
  
  let content: Content
  
  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  var body: some View {
    NBNavigationStack {
      CustomNavBarContainerView {
        content
      }
      .navigationBarHidden(true)
    }
  }
}

struct CustomNavView_Previews: PreviewProvider {
  static var previews: some View {
    CustomNavView {
      Color.red.ignoresSafeArea()
    }
  }
}

extension UINavigationController {
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = nil
  }
}
