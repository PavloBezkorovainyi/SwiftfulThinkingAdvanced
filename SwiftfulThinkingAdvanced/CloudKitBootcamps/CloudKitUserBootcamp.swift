//
//  CloudKitUserBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Pavlo Bezkorovainyi on 16.04.2024.
//

import SwiftUI
import CloudKit

class CloudKitBootcampViewModel: ObservableObject {
  
  @Published var permissionStatus: Bool = false
  @Published var isSignedInToiCloud: Bool = false
  @Published var error: String = ""
  @Published var userName: String = ""
  
  init() {
    getiCloudStatus()
    requestPermission()
    fetchiCloudUserRecodID()
  }
  
  private func getiCloudStatus() {
    CKContainer.default().accountStatus { [weak self] returnedStatus, returnedError in
      DispatchQueue.main.async {
        switch returnedStatus {
        case .available:
          self?.isSignedInToiCloud = true
        case .restricted:
          self?.error = CLoudKitError.iCloudAccountRestricted.rawValue
        case .couldNotDetermine:
          self?.error = CLoudKitError.iCloudAccountNotDetermined.rawValue
        case .noAccount:
          self?.error = CLoudKitError.iCloudAccountNotFound.rawValue
        default:
          self?.error = CLoudKitError.iCloudAccountUnknown.rawValue
        }
      }
    }
  }
  
  enum CLoudKitError: String, LocalizedError {
    case iCloudAccountNotFound
    case iCloudAccountNotDetermined
    case iCloudAccountRestricted
    case iCloudAccountUnknown
  }
  
  func requestPermission() {
    CKContainer.default().requestApplicationPermission([.userDiscoverability]) { returnedStatus, returnedError in
      DispatchQueue.main.async {
        if returnedStatus == .granted {
          self.permissionStatus = true
        }
      }
    }
  }
  
  func fetchiCloudUserRecodID() {
    CKContainer.default().fetchUserRecordID { [weak self] returnedId, returnedError in
      if let id = returnedId {
        self?.discoveriCloudUser(id: id)
      }
    }
  }
  
  func discoveriCloudUser(id: CKRecord.ID) {
    CKContainer.default().discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, returnedError in
      DispatchQueue.main.async {
        if let name = returnedIdentity?.nameComponents?.givenName {
          self?.userName = name
        }
      }
    }
  }
}

struct CloudKitUserBootcamp: View {
  
  @StateObject private var vm = CloudKitBootcampViewModel()
  
  var body: some View {
    Text("IS SIGNED IN: \(vm.isSignedInToiCloud.description.uppercased())")
    Text(vm.error)
    Text("Permission: \(vm.permissionStatus.description.uppercased()) ")
    Text("NAME: \(vm.userName)")
  }
}

#Preview {
  CloudKitUserBootcamp()
}
