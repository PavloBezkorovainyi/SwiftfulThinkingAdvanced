//
//  ViewBuilderBootcamp.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 01.10.2023.
//

import SwiftUI

struct HeaderViewRegular: View {
  
  let title: String
  let description: String?
  let iconName: String?
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.largeTitle)
        .fontWeight(.semibold)
      
      if let description {
        Text(description)
          .font(.callout)
      }
      
      if let iconName {
        Image(systemName: iconName)
      }
      
      RoundedRectangle(cornerRadius: 5)
        .frame(height: 2)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
  }
}

struct HeaderViewGeneric<Content: View>: View {
  
  let title: String
  let content: Content
  
  init(title: String, @ViewBuilder content: () -> Content) {
    self.title = title
    self.content = content()
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.largeTitle)
        .fontWeight(.semibold)
      
      content
      
      RoundedRectangle(cornerRadius: 5)
        .frame(height: 2)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
  }
}

struct CustomHStack<Content: View>: View {
  
  let content: Content
  
  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  var body: some View {
    HStack {
      content
    }
    .foregroundColor(.red)
  }
}

struct ViewBuilderBootcamp: View {
  var body: some View {
    VStack {
      HeaderViewRegular(title: "New Title", description: "Description", iconName: "heart.fill")
      
      HeaderViewRegular(title: "Another Title", description: nil, iconName: nil)
      
      HeaderViewGeneric(title: "Generic 2") {
        Text("Hi")
      }
      
      HeaderViewGeneric(title: "Generic 3") {
        HStack {
          Text("Hello")
          Image(systemName: "heart.fill")
        }
      }
      
      CustomHStack {
        Text("Hi")
        Text("Hi")
      }
      
      HStack {
        Text("Hi")
        Text("Hi")
      }
      
      
      Spacer()
    }
  }
}

struct ViewBuilderBootcamp_Previews: PreviewProvider {
  static var previews: some View {
    //        ViewBuilderBootcamp()
    LocalViewBuilder(type: .three)
  }
}

struct LocalViewBuilder: View {
  
  enum ViewType {
    case one, two, three
  }
  
  let type: ViewType
  
  var body: some View {
    VStack {
      headerSection
    }
  }
  
  @ViewBuilder private var headerSection: some View {
    switch type {
    case .one: viewOne
    case .two: viewTwo
    case .three: viewThree
    }
  }
  
  private var viewOne: some View {
    Text("One!")
  }
  
  private var viewTwo: some View {
    VStack {
      Text("TWOO!")
      Image(systemName: "heart.fill")
    }
  }
  
  private var viewThree: some View {
    Image(systemName: "heart.fill")
  }
}
