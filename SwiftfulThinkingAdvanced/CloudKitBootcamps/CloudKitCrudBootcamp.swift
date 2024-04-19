//
//  CloudKitCrudBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Pavlo Bezkorovainyi on 18.04.2024.
//

import SwiftUI
import CloudKit

struct FruitModel: Hashable {
  let name: String
  let imageURL: URL?
  let record: CKRecord
}

class CloudKitCrudBootcampViewModel: ObservableObject {
  
  @Published var text: String = ""
  @Published var fruits: [FruitModel] = []
  
  init() {
    fetchItems()
  }
  
  func addButtonPressed() {
    guard !text.isEmpty else { return }
    addItem(name: text)
  }
  
  private func addItem(name: String) {
    let newFruit = CKRecord(recordType: "Fruits")
    newFruit["name"] = name
    
    guard let image = UIImage(named: "surfing-shark"), 
    let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("surfing-shark.png"),
    let data = image.jpegData(compressionQuality: 1.0) else { return }
    
    do {
      try data.write(to: url)
      let asset = CKAsset(fileURL: url)
      newFruit["image"] = asset
      saveItem(record: newFruit)
    } catch let error {
      print(error.localizedDescription)
    }
  }
  
  private func saveItem(record: CKRecord) {
    CKContainer.default().publicCloudDatabase.save(record) { [weak self] returnedRecord, returnedError in
      print("Record: \(returnedRecord)")
      print("Error: \(returnedError)")
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        self?.text.removeAll()
        self?.fetchItems()
      }
    }
  }
  
  func fetchItems() {
    let predicate = NSPredicate(value: true)
//    let predicate = NSPredicate(format: "name = %@", argumentArray: ["Coconut"])
    let query = CKQuery(recordType: "Fruits", predicate: predicate)
    query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    let queryOperation = CKQueryOperation(query: query)
//    queryOperation.resultsLimit = 2 //100 by default
    
    var returnedItems: [FruitModel] = []
    
    if #available(iOS 15.0, *) {
      queryOperation.recordMatchedBlock = { returnedRecordId, returnedResult in
        switch returnedResult {
        case .success(let record): 
          guard let name = record["name"] as? String else { return }
          let imageAsset = record["image"] as? CKAsset
          let imageURL = imageAsset?.fileURL
          print(record)
          returnedItems.append(FruitModel(name: name, imageURL: imageURL, record: record))
        case .failure(let error):
          print("recordMatchedBlock: \(error)")
        }
      }
    } else {
      queryOperation.recordFetchedBlock = { returnedRecord in
        guard let name = returnedRecord["name"] as? String else { return }
        let imageAsset = returnedRecord["image"] as? CKAsset
        let imageURL = imageAsset?.fileURL
        returnedItems.append(FruitModel(name: name, imageURL: imageURL, record: returnedRecord))
      }
    }
    
    if #available(iOS 15.0, *) {
      queryOperation.queryResultBlock = { [weak self] returnedResult in
        print("RETURNED queryResultBlock: \(returnedResult)")
        DispatchQueue.main.async {
          self?.fruits = returnedItems
        }
      }
    } else {
      queryOperation.queryCompletionBlock = { [weak self] returnedCursor, error in
        print("RETURNED queryCompletionBlock:")
        DispatchQueue.main.async {
          self?.fruits = returnedItems
        }
      }
    }
    
    addOperation(operation: queryOperation)
  
  }
  
  func addOperation(operation: CKDatabaseOperation) {
    CKContainer.default().publicCloudDatabase.add(operation)
  }
  
  func updateItem(fruit: FruitModel) {
    let record = fruit.record
    record["name"] = "NEW NAME!!"
    saveItem(record: record)
  }
  
  func deleteItem(indexSet: IndexSet) {
    guard let index = indexSet.first else { return }
    let fruit = fruits[index]
    let record = fruit.record
    
    CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID) { [weak self] returnedRecordId, returnedError in
      DispatchQueue.main.async {
        self?.fruits.remove(at: index)
      }
    }
  }
}

struct CloudKitCrudBootcamp: View {
  
  @StateObject private var vm = CloudKitCrudBootcampViewModel()
  
  var body: some View {
    NavigationView {
      VStack {
        header
        textField
        addButton
        
        List {
          ForEach(vm.fruits, id: \.self) { fruit in
            HStack {
              Text(fruit.name)
              if let url = fruit.imageURL, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                Image(uiImage: image)
                  .resizable()
                  .frame(width: 50, height: 50)
              }
            }
            .onTapGesture {
              vm.updateItem(fruit: fruit)
            }
          }
          .onDelete(perform: vm.deleteItem)
        }
        .listStyle(.plain)
      }
      .padding()
      .navigationBarHidden(true)
    }
  }
}

#Preview {
  CloudKitCrudBootcamp()
}

extension CloudKitCrudBootcamp {
  
  private var header: some View {
    Text("CloudKit CRUD ☁️☁️☁️")
      .font(.headline)
      .underline()
  }
  
  private var textField: some View {
    TextField("Add something here", text: $vm.text)
      .frame(height: 55)
      .padding(.leading)
      .background(Color.gray.opacity(0.4))
      .cornerRadius(10)
  }
  
  private var addButton: some View {
    Button(action: {
      vm.addButtonPressed()
    }, label: {
      Text("Add")
        .frame(height: 55)
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(Color.pink)
        .cornerRadius(10)
    })
  }
}
