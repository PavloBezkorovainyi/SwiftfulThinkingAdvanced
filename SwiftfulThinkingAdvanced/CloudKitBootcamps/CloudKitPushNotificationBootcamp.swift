//
//  CloudKitPushNotificationBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Pavlo Bezkorovainyi on 19.04.2024.
//

import SwiftUI
import CloudKit

class CloudKitPushNotificationBootcampViewModel: ObservableObject {
  
  func requestNotificationPermissions() {
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
      if let error {
        print(error)
      } else if success {
        print("Notification permission success!")
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      } else {
        print("Notification permissions failure.")
      }
    }
  }
  
  func subscribeToNotifications() {
    let predicate = NSPredicate(value: true)
    
    let subscription = CKQuerySubscription(recordType: "Fruits", predicate: predicate, subscriptionID: "fruit_added_to_database", options: .firesOnRecordCreation)
    
    let notification = CKSubscription.NotificationInfo()
    notification.title = "There is a new fruit!"
    notification.alertBody = "Open the app to check your fruits."
    notification.soundName = "default"
    
    
    subscription.notificationInfo = notification
    
    CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
      if let error = returnedError {
        print(error)
      } else {
        print("Successfully subscribed to notifcations!")
      }
    }
  }
  
  func unsubscribeToNotifictions() {
    
//    CKContainer.default().publicCloudDatabase.fetchAllSubscriptions(completionHandler: )
    
    CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "fruit_added_to_database") { returnedID, returnedError in
      if let error = returnedError {
        print(error)
      } else {
        print("Succesfully unsubscribed!")
      }
    }
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
