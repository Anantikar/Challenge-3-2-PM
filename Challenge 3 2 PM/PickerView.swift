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
    @State var dogName = ""
    var body: some View {
        VStack {
            DogImageView()
            HStack {
                Text("When does \(dogName) wanna sleep")
                    .font(.headline)
                    .padding()
                DatePicker("", selection: $bedtime, displayedComponents: .hourAndMinute)
                    .padding()
            }
            HStack {
                Text("When does \(dogName) wanna wake up")
                    .font(.headline)
                    .padding()
                DatePicker("", selection: $wakeup, displayedComponents: .hourAndMinute)
                    .padding()
                
            }
            Button {
                print("save")
            } label: {
                Text("Save")
            }
        }
    }
}
#Preview {
    PickerView()
}


