//
//  UITestingBootcampView.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 21.03.2024.
//

import SwiftUI

class UITestBootcampViewModel: ObservableObject {
  
  let placeHodlerText: String = "Add your name..."
  @Published var textFieldText: String = ""
  @Published var currentUserIsSignedIn: Bool
  
  init(currentUserIsSignedIn: Bool) {
    self.currentUserIsSignedIn = currentUserIsSignedIn
  }
  
  func signUpButtonPressed() {
    guard !textFieldText.isEmpty else { return }
    currentUserIsSignedIn = true
  }
}

struct UITestingBootcampView: View {
  
  @StateObject private var vm: UITestBootcampViewModel
  
  init(currentUserIsSignedIn: Bool) {
    _vm = StateObject(wrappedValue: UITestBootcampViewModel(currentUserIsSignedIn: currentUserIsSignedIn))
  }
  
  var body: some View {
    ZStack {
      LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color.black]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
      .ignoresSafeArea()
      
      ZStack {
        if vm.currentUserIsSignedIn {
          SignedInHomeView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .transition(.move(edge: .trailing))
        } else {
          signUpLayer
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .transition(.move(edge: .leading))
        }
      }
    }
  }
}

extension UITestingBootcampView {
  
  private var signUpLayer: some View {
    VStack {
      TextField(vm.placeHodlerText, text: $vm.textFieldText)
        .font(.headline)
        .padding()
        .background(Color.white.cornerRadius(10))
        .accessibilityIdentifier("SignUpTextField")
      
      Button {
        withAnimation(.spring) {
          vm.signUpButtonPressed()
        }
       
      } label: {
        Text("Sign Up")
          .font(.headline)
          .padding()
          .frame(maxWidth: .infinity)
          .foregroundColor(.white)
          .background(Color.blue.cornerRadius(10))
      }
      .accessibilityIdentifier("SignUpButton")
    }
    .padding()
  }
}

#Preview {
  UITestingBootcampView(currentUserIsSignedIn: true)
}


struct SignedInHomeView: View {
  
  @State private var showAlert: Bool = false
  
  var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        Button(action: {
          showAlert.toggle()
        }, label: {
          Text("Show welcome alert")
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.red.cornerRadius(10))
        })
        .accessibilityIdentifier("ShowAlertButton")
        .alert(isPresented: $showAlert, content: {
          return Alert(title: Text("Welcome to the app!"))
        })
        
        NavigationLink {
          Text("Destination")
        } label: {
          Text("Navigate")
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.blue.cornerRadius(10))
        }
        .accessibilityIdentifier("NavigationLinkToDestination")

      }
      .padding()
      .navigationTitle("Welcome")
    }
  }
}
