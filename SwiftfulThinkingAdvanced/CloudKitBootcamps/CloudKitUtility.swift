//
//  CloudKitUtility.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Pavlo Bezkorovainyi on 20.04.2024.
//

import SwiftUI
import CloudKit
import Combine

protocol CloudKitRecordModelProtocol {
  init?(record: CKRecord)
  var record: CKRecord { get }
}

class CloudKitUtility {
  
  enum CLoudKitError: String, LocalizedError {
    case iCloudAccountNotFound
    case iCloudAccountNotDetermined
    case iCloudAccountRestricted
    case iCloudAccountUnknown
    case iCloudApplicationPermissionNotGranted
    case iCloudCouldNotFetchUserRecordID
    case iCloudCouldNotDiscoverUser
    
    case iCloudNotificationPermissionFailure
  }
}

//MARK: USER FUNCTIONS
extension CloudKitUtility {
  
  static private func getiCloudStatus(completion: @escaping(Result<Bool, Error>) -> ()) {
    CKContainer.default().accountStatus { returnedStatus, returnedError in
      switch returnedStatus {
      case .available:
        completion(.success(true))
      case .restricted:
        completion(.failure(CLoudKitError.iCloudAccountRestricted))
      case .couldNotDetermine:
        completion(.failure(CLoudKitError.iCloudAccountNotDetermined))
      case .noAccount:
        completion(.failure(CLoudKitError.iCloudAccountNotFound))
      default:
        completion(.failure(CLoudKitError.iCloudAccountUnknown))
      }
    }
  }
  
  static func getiCloudStatus() -> Future<Bool, Error> {
    Future { promise in
      CloudKitUtility.getiCloudStatus { result in
        promise(result)
      }
    }
  }
  
  static private func requestApplicationPermission(completion: @escaping(Result<Bool, Error>) -> ()) {
    CKContainer.default().requestApplicationPermission([.userDiscoverability]) { returnedStatus, returnedError in
      if returnedStatus == .granted {
        completion(.success(true))
      } else {
        completion(.failure(CLoudKitError.iCloudApplicationPermissionNotGranted))
      }
    }
  }
  
  static func requestApplicationPermission() -> Future<Bool, Error> {
    Future { promise in
      CloudKitUtility.requestApplicationPermission { result in
        promise(result)
      }
    }
  }
  
  static private func fetchUserRecordID(completion: @escaping(Result<CKRecord.ID, Error>) -> ()) {
    CKContainer.default().fetchUserRecordID { returnedId, returnedError in
      if let id = returnedId {
        completion(.success(id))
      } else if let error = returnedError {
        completion(.failure(error))
      } else {
        completion(.failure(CLoudKitError.iCloudCouldNotFetchUserRecordID))
      }
    }
  }
  
  static private func discoverUserIdentity(id: CKRecord.ID, completion: @escaping(Result<String, Error>) -> ()) {
    CKContainer.default().discoverUserIdentity(withUserRecordID: id) { returnedIdentity, returnedError in
      if let name = returnedIdentity?.nameComponents?.givenName {
        completion(.success(name))
      } else {
        completion(.failure(CLoudKitError.iCloudCouldNotDiscoverUser))
      }
    }
  }
  
  static private func discoverUserIdentity(completion: @escaping(Result<String, Error>) -> ()) {
    fetchUserRecordID { fetchedCompletion in
      switch fetchedCompletion {
      case .success(let recordID):
        discoverUserIdentity(id: recordID, completion: completion)
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  static func discoverUserIdentity() -> Future<String, Error> {
    Future { promise in
      CloudKitUtility.discoverUserIdentity { result in
        promise(result)
      }
    }
  }
}

//MARK: CRUD FUNCTIONS
extension CloudKitUtility {
  
  static func fetch<T: CloudKitRecordModelProtocol>(
    predicate: NSPredicate,
    recordType: CKRecord.RecordType,
    sortDescriptors:[NSSortDescriptor]? = nil,
    resultsLimit: Int? = nil) -> Future<[T], Error> {
      Future { promise in
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType, sortDescriptors: sortDescriptors, resultsLimit: resultsLimit) { (items: [T]) in
          promise(.success(items))
        }
      }
    }
  
  static private func fetch<T: CloudKitRecordModelProtocol>(
    predicate: NSPredicate,
    recordType: CKRecord.RecordType,
    sortDescriptors:[NSSortDescriptor]? = nil,
    resultsLimit: Int? = nil,
    completion: @escaping (_ items: [T]) -> ()) {
      //create operation
      let operation = createOperation(predicate: predicate, recordType: recordType, sortDescriptors: sortDescriptors, resultsLimit: resultsLimit)
      
      //Get items in query
      var returnedItems: [T] = []
      addRecordMathedBlock(operation: operation) { item in
        returnedItems.append(item)
      }
      
      //Query completion
      addQueryResultBlock(operation: operation) { finished in
        completion(returnedItems)
      }
      
      //Execute operation
      addOperation(operation: operation)
    }
  
  static private func createOperation(
    predicate: NSPredicate,
    recordType: CKRecord.RecordType,
    sortDescriptors:[NSSortDescriptor]? = nil,
    resultsLimit: Int? = nil) -> CKQueryOperation {
      let query = CKQuery(recordType: recordType, predicate: predicate)
      query.sortDescriptors = sortDescriptors
      let queryOperation = CKQueryOperation(query: query)
      if let resultsLimit {
        queryOperation.resultsLimit = resultsLimit
      }
      return queryOperation
    }
  
  static private func addRecordMathedBlock<T: CloudKitRecordModelProtocol>(operation: CKQueryOperation, completion: @escaping(_ item: T) -> ()) {
    operation.recordMatchedBlock = { returnedRecordId, returnedResult in
      switch returnedResult {
      case .success(let record):
        guard let item = T(record: record) else { return }
        completion(item)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  static private func addQueryResultBlock(operation: CKQueryOperation, completion: @escaping(_ finished: Bool) -> ()) {
    operation.queryResultBlock = { returnedResult in
      completion(true)
    }
  }
  
  static private func addOperation(operation: CKDatabaseOperation) {
    CKContainer.default().publicCloudDatabase.add(operation)
  }
  
  static func add<T: CloudKitRecordModelProtocol>(item: T, completion: @escaping (Result<Bool, Error>) -> ()) {
    
    //Get record
    let record = item.record
    
    //Save to CloudKit
    save(record: record, completion: completion)
  }
  
  static func update<T: CloudKitRecordModelProtocol>(item: T, completion: @escaping (Result<Bool, Error>) -> ()) {
    
    add(item: item, completion: completion)
  }
  
  static func save(record: CKRecord, completion: @escaping (Result<Bool, Error>) -> ()) {
    CKContainer.default().publicCloudDatabase.save(record) { returnedRecord, returnedError in
      if let error = returnedError {
        completion(.failure(error))
      } else {
        completion(.success(true))
      }
    }
  }
  
  static func delete<T: CloudKitRecordModelProtocol>(item: T) -> Future<Bool, Error> {
    Future { promise in
      CloudKitUtility.delete(item: item, completion: promise)
    }
    
  }
  
  static private func delete<T: CloudKitRecordModelProtocol>(item: T, completion: @escaping (Result<Bool, Error>) -> ()) {
    CloudKitUtility.delete(record: item.record, completion: completion)
  }
  
  static private func delete(record: CKRecord, completion: @escaping (Result<Bool, Error>) -> ()) {
    CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID) { returnedRecordId, returnedError in
      if let error = returnedError {
        completion(.failure(error))
      } else {
        completion(.success(true))
      }
    }
  }
}

//MARK: NOTIFICATIONS FUNCTIONS
extension CloudKitUtility {
  static func requestNotificationPermissions() -> Future<Bool, Error> {
    Future { promise in
      CloudKitUtility.requestApplicationPermission(completion: promise)
    }
  }
  
  static private func requestNotificationPermissions(completion: @escaping (Result<Bool, Error>) -> ()) {
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
      if success {
        completion(.success(true))
      } else if let error {
        completion(.failure(error))
      } else {
        completion(.failure(CLoudKitError.iCloudNotificationPermissionFailure))
      }
    }
  }
  
  static func subscribeToNotifications(
    recordType: CKRecord.RecordType,
    predicate: NSPredicate = NSPredicate(value: true),
    subscriptionID: CKSubscription.ID,
    options: CKQuerySubscription.Options,
    notificationTitle: String,
    notificationAlertBody: String,
    notificationSoundName: String = "default") -> Future<Bool, Error> {
      Future { promise in
        CloudKitUtility.subscribeToNotifications(
          recordType: recordType,
          predicate: predicate,
          subscriptionID: subscriptionID,
          options: options,
          notificationTitle: notificationTitle,
          notificationAlertBody: notificationAlertBody,
          notificationSoundName: notificationSoundName,
          completion: promise)
      }
    }
  
  static private func subscribeToNotifications(
    recordType: CKRecord.RecordType,
    predicate: NSPredicate = NSPredicate(value: true),
    subscriptionID: CKSubscription.ID,
    options: CKQuerySubscription.Options,
    notificationTitle: String,
    notificationAlertBody: String,
    notificationSoundName: String = "default",
    completion: @escaping (Result<Bool, Error>) -> ()) {
      
      let subscription = CKQuerySubscription(recordType: recordType, predicate: predicate, subscriptionID: subscriptionID, options: options)
      
      let notification = CKSubscription.NotificationInfo()
      notification.title = notificationTitle
      notification.alertBody = notificationAlertBody
      notification.soundName = notificationSoundName
      
      subscription.notificationInfo = notification
      
      CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
        if let error = returnedError {
          completion(.failure(error))
        } else {
          completion(.success(true))
        }
      }
    }
  
  static func unsubscribeToNotifiction(with subscriptionID: CKSubscription.ID) -> Future<Bool, Error> {
    Future { promise in
      CloudKitUtility.unsubscribeToNotifiction(with: subscriptionID, completion: promise)
    }
  }
  
  static private func unsubscribeToNotifiction(with subscriptionID: CKSubscription.ID, completion: @escaping (Result<Bool, Error>) -> ()) {
    CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: subscriptionID) { returnedID, returnedError in
      if let error = returnedError {
        completion(.failure(error))
      } else {
        completion(.success(true))
      }
    }
  }
}
