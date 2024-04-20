//
//  CloudKitUserBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Pavlo Bezkorovainyi on 16.04.2024.
//

import SwiftUI
import CloudKit
import Combine

class CloudKitBootcampViewModel: ObservableObject {
  
  @Published var permissionStatus: Bool = false
  @Published var isSignedInToiCloud: Bool = false
  @Published var error: String = ""
  @Published var userName: String = ""
  
  var canlcellables = Set<AnyCancellable>()
  
  init() {
    getiCloudStatus()
    requestPermission()
    getCurrentUserName()
  }
  
  private func getiCloudStatus() {
    CloudKitUtility.getiCloudStatus()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        switch completion {
        case .finished: break
        case .failure(let error):
          self?.error = error.localizedDescription
        }
      } receiveValue: { [weak self] success in
        self?.isSignedInToiCloud = success
      }
      .store(in: &canlcellables)
  }
  
  func requestPermission() {
    CloudKitUtility.requestApplicationPermission()
      .receive(on: DispatchQueue.main)
      .sink { _ in
      } receiveValue: { [weak self] success in
        self?.permissionStatus = success
      }
      .store(in: &canlcellables)
  }
  
  func getCurrentUserName() {
    CloudKitUtility.discoverUserIdentity()
      .receive(on: DispatchQueue.main)
      .sink { _ in
      } receiveValue: { [weak self] returnedName in
        self?.userName = returnedName
      }
      .store(in: &canlcellables)
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
