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
    @Bindable var dogManager: DogManager

    var body: some View {
        VStack {
            DogImageView(dogManager: dogManager)

            HStack {
                Text("When does \(dogManager.name) wanna sleep")
                    .font(.headline)
                    .padding()
                DatePicker("", selection: $bedtime, displayedComponents: .hourAndMinute)
                    .padding()
            }
            HStack {
                Text("When does \(dogManager.name) wanna wake up")
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
    PickerView(dogManager: DogManager())
}


