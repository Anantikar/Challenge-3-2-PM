//
//  PickerView.swift
//  Challenge 3 2 PM
//
//  Created by swiftinsg on 10/11/25.
//
import SwiftUI
struct PickerView: View {
    @State private var bedtime = Date.now
    @State private var wakeup = Date.now
    @State private var inputText: String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("What time does dawg wanna sleep")
                .font(.headline)
        }
        HStack {
            DatePicker("", selection: $bedtime, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(.wheel)
        }
        VStack {
            Text("How long does dawg wanna sleep for")
                .bold()
            TextField("Enter your text here", text: $inputText)
                .textFieldStyle(.roundedBorder)
        }
        VStack(alignment: .leading, spacing: 6) {
            Text("When does dawg wanna wake up")
                .font(.headline)
        }
        HStack {
            DatePicker("", selection: $wakeup, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(.wheel)
        }
    }
}
#Preview {
    PickerView()
}


