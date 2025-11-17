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
        VStack {
            DogImageView(level: 1, emotion: .happy)
            HStack {
                Text("What time does dawg wanna sleep")
                    .font(.headline)
                    .padding()
                DatePicker("", selection: $bedtime, displayedComponents: .hourAndMinute)
                    .padding()
            }
            HStack {
                Text("When does dawg wanna wake up")
                    .font(.headline)
                    .padding()
                DatePicker("", selection: $wakeup, displayedComponents: .hourAndMinute)
                    .padding()
                
            }
        }
    }
}
#Preview {
    PickerView()
}


