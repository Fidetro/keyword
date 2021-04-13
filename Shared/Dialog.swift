//
//  Dialog.swift
//  keyword
//
//  Created by Fidetro on 2021/4/13.
//

import SwiftUI

struct InputDialog: View {
    @Environment(\.presentationMode) var presentationMode

    /// Edited value, passed from outside
    @Binding var value1: String?
    
    /// Edited value, passed from outside
    @Binding var value2: String?

    /// Prompt message
    var prompt: String = ""
    
    /// The value currently edited
    @State var fieldValue1: String
    
    /// The value currently edited
    @State var fieldValue2: String
    
    /// Init the Dialog view
    /// Passed @binding value is duplicated to @state value while editing
    init(prompt: String, value1: Binding<String?>,value2: Binding<String?>) {
        _value1 = value1
        _value2 = value2
        self.prompt = prompt
        _fieldValue1 = State<String>(initialValue: value1.wrappedValue ?? "")
        _fieldValue2 = State<String>(initialValue: value2.wrappedValue ?? "")
    }

    var body: some View {
        VStack {
            Text(prompt).padding()
            TextField("英文", text: $fieldValue1)
                .frame(width: 200, alignment: .center)
            TextField("中文", text: $fieldValue2)
                .frame(width: 200, alignment: .center)
            HStack {
            Button("OK") {
                self.value1 = fieldValue1
                self.value2 = fieldValue2
                self.presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            }
            }.padding()
        }
        .padding()
    }
}

#if DEBUG
struct InputDialog_Previews: PreviewProvider {

    static var previews: some View {
        var name = "John Doe"
        InputDialog(prompt: "Name", value1: Binding<String?>.init(get: { name }, set: {name = $0 ?? ""}), value2: Binding<String?>.init(get: { name }, set: {name = $0 ?? ""}))        
    }
}
#endif

struct Dialog: View {
    @Environment(\.presentationMode) var presentationMode

    /// Prompt message
    var prompt: String = ""

    
    /// Init the Dialog view
    /// Passed @binding value is duplicated to @state value while editing
    init(prompt: String) {
        self.prompt = prompt
    }

    var body: some View {
        VStack {
            Text(prompt).padding()
            HStack {
            Button("OK") {
                self.presentationMode.wrappedValue.dismiss()
            }
            }.padding()
        }
        .padding()
    }
}

#if DEBUG
struct Dialog_Previews: PreviewProvider {

    static var previews: some View {
        Dialog(prompt: "Name")
    }
}
#endif
