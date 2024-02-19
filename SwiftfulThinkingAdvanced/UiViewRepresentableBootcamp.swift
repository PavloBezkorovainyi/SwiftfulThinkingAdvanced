import SwiftUI

struct UiViewRepresentableBootcamp: View {
  @State private var text: String = ""
  
  var body: some View {
    VStack {
      Text(text)
      
      HStack {
        Text("SwiftUI")
        TextField("Type here..", text: $text)
          .frame(height: 55)
          .background(Color.gray)
      }
        
      HStack {
        Text("UIKit")
        UITextFieldViewRepresentable(text: $text)
          .updatePlaceholder(text: "New placeholder!!!")
          .frame(height: 55)
          .background(Color.gray)
      }
      
    }
  }
}

#Preview {
  UiViewRepresentableBootcamp()
}

struct UITextFieldViewRepresentable: UIViewRepresentable {
  @Binding var text: String
  var placeHolder: String
  let placeholderColor: UIColor
  
  init(text: Binding<String>, placeHolder: String = "Default placeholder...", placeholderColor: UIColor = .red) {
    self._text = text
    self.placeHolder = placeHolder
    self.placeholderColor = placeholderColor
  }
  
  func makeUIView(context: Context) -> UITextField {
   let textField = getTextField()
    textField.delegate = context.coordinator
    return textField
  }
  
  
  //from SwiftUI to UIKit
  func updateUIView(_ uiView: UITextField, context: Context) {
    uiView.text = text
  }
  
  private func getTextField() -> UITextField {
    let textfield = UITextField(frame: .zero)
    let placeholder = NSAttributedString(
      string: placeHolder,
      attributes: [
        .foregroundColor : placeholderColor
                  ])
    textfield.attributedPlaceholder = placeholder
    return textfield
  }
  
  func updatePlaceholder(text: String) -> UITextFieldViewRepresentable {
    var viewRepresentable = self
    viewRepresentable.placeHolder = text
    return viewRepresentable
  }
  
  //from UIKit to SwiftUI
  func makeCoordinator() -> Coordinator {
    return Coordinator(text: $text)
  }
  
  class Coordinator: NSObject, UITextFieldDelegate {
    @Binding var text: String
    
    init(text: Binding<String>) {
      self._text = text
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
      text = textField.text ?? ""
    }
  }
}

struct BasicUIViewRepresentable: UIViewRepresentable {
  func makeUIView(context: Context) -> some UIView {
    let view = UIView()
    view.backgroundColor = .red
    return view
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    
  }
  
}
