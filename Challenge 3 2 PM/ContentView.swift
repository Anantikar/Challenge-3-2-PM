//
//  ContentView.swift
//  Challenge 3 2 PM
//
//  Created by Anantika Tiwari on 10/11/25.
//

import SwiftUI

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
// How It Works
//Remove the ‘#’: The code checks for and ignores the leading # character if it exists.
//Convert to Hex: scanHexInt64(&rgb) parses the remaining string into a UInt64 value.
//Extract RGB Values: Bitwise operations calculate separate red, green, and blue values.
//Normalize to SwiftUI’s Color: Each component is divided by 255.0 to get the normalized color used by SwiftUI.
struct ContentView: View {
    @State private var isPickerPresented = false
    @State private var isEvolutionPresented = false
    var body: some View {
        NavigationStack {
            VStack {
                Text("dawg jumps when tapped")
                Text("dawg is sad")
                    .font(.largeTitle)
                Text("go play with him!")
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
                    BlockAppsView()
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
        .padding()
    }
}

#Preview {
    ContentView()
}
