//
//  GenericsBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 26.09.2023.
//

import SwiftUI

struct StringModel {
  let info: String?
  
  func removeInfo() -> StringModel {
    StringModel(info: nil)
  }
}

struct BoolModel {
  let info: Bool?
  
  func removeInfo() -> BoolModel {
    BoolModel(info: nil)
  }
}

struct GenericModel<T> {
  let info: T?
  func removeInfo() -> GenericModel {
    GenericModel(info: nil)
  }
}

struct GenericView<T: View>: View {
  
  let content: T
  let title: String
  
  var body: some View {
    VStack {
      Text(title)
      content
    }

  }
  
}


class GenericsViewModel: ObservableObject {


  
}

struct GenericsBootcamp: View {
  
  @StateObject private var vm = GenericsViewModel()
  
  var body: some View {
    VStack {
      Text("hi")
    }
  }
}

struct GenericsBootcamp_Previews: PreviewProvider {
  static var previews: some View {
    GenericsBootcamp()
  }
}
