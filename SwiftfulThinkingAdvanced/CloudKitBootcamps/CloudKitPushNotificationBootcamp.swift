//
//  CloudKitPushNotificationBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Pavlo Bezkorovainyi on 19.04.2024.
//

import SwiftUI
import Combine

class CloudKitPushNotificationBootcampViewModel: ObservableObject {
  private var canclellables = Set<AnyCancellable>()
  
  func requestNotificationPermissions() {
    CloudKitUtility.requestApplicationPermission()
      .receive(on: DispatchQueue.main)
      .sink { error in
        print(error)
      } receiveValue: { success in
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
      .store(in: &canclellables)
  }
  
  func subscribeToNotifications() {
    CloudKitUtility.subscribeToNotifications(
      recordType: "Fruits",
      subscriptionID: "fruit_added_to_database",
      options: .firesOnRecordCreation,
      notificationTitle: "There is a new fruit!",
      notificationAlertBody: "Open the app to check your fruits.")
    .receive(on: DispatchQueue.main)
    .sink { error in
      print(error)
    } receiveValue: { success in
      print("Successfully subscribed to notifcations!")
    }
    .store(in: &canclellables)
  }
  
  func unsubscribeToNotifictions() {
    
    CloudKitUtility.unsubscribeToNotifiction(with: "fruit_added_to_database")
      .receive(on: DispatchQueue.main)
      .sink { error in
        print(error)
      } receiveValue: { success in
        print("Succesfully unsubscribed!")
      }
      .store(in: &canclellables)
  }
}

struct CloudKitPushNotificationBootcamp: View {
  
  @StateObject private var vm = CloudKitPushNotificationBootcampViewModel()
  
  var body: some View {
    VStack(spacing: 40) {
      
      Button("Request notification permissions") {
        vm.requestNotificationPermissions()
      }
      
      Button("Subscribe to notifications") {
        vm.subscribeToNotifications()
      }
      
      Button("Unsubscribe to notifications") {
        vm.unsubscribeToNotifictions()
      }
    }
  }
}

#Preview {
  CloudKitPushNotificationBootcamp()
}
