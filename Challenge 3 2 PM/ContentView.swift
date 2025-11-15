//
//  ContentView.swift
//  Challenge 3 2 PM
//
//  Created by Anantika Tiwari on 10/11/25.
//

import SwiftUI
import FamilyControls

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct ContentView: View {
    @ObservedObject var manager: ShieldManager
    @State private var isPickerPresented = false
    @State private var isEvolutionPresented = false
    @State private var dogName: String = ""
    var body: some View {
        NavigationStack {
            VStack {
                DogImageView(level: 1, emotion: .happy)
                Text("Choose a name for your dog!")
                TextField("E.g. dawg ", text: $dogName)
                    .textFieldStyle(.roundedBorder)
                Text("\(dogName) jumps when tapped")
                Text("\(dogName) is sad")
                    .font(.largeTitle)
                Text("go play with it!")
                    .font(.largeTitle)
                Button {
                    isPickerPresented = true
                } label: {
                    Text("Bedtime")
                        .foregroundStyle(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#d0e4f7"))
                        .cornerRadius(20)
                }
                .sheet(isPresented: $isPickerPresented) {
                    PickerView()
                }
                NavigationLink {
                    AppsOverviewView(manager: manager, dogName: dogName)
                } label: {
                    Text("Apps blocked")
                        .foregroundStyle(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#d0e4f7"))
                        .cornerRadius(20)
                }
                Button {
                    isEvolutionPresented = true
                } label: {
                    Text("❤️ till evolution")
                        .foregroundStyle(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#d0e4f7"))
                        .cornerRadius(20)
                }
                .sheet(isPresented: $isEvolutionPresented) {
                    EvolutionView()
                }
            }
        }
    }
}


#Preview {
    ContentView(manager: ShieldManager())
}
