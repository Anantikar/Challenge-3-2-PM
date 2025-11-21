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
    @State private var isStatsPresented = false
    
    @State private var isNameFinal = false
    @StateObject var dogManager = DogManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("wallpaper")
                    .resizable()
                    .ignoresSafeArea()
                VStack(spacing: 16) {
                    DogImageView(dogManager: dogManager)
                    if !isNameFinal {
                        Text("don't leave dawg nameless 🙁")
                            .foregroundStyle(.white)
                        
                        TextField("E.g. dawg", text: $dogManager.name)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                        
                        Button("Save name") {
                            isNameFinal = true
                        }
                        .padding(.bottom)
                    }
                    if isNameFinal {
                        Text("\(dogManager.name) is \(dogManager.emotion.rawValue)")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                    }
                    if dogManager.emotion == .dead{
                        Text("revive me!")
                            .font(.headline)
                            .foregroundStyle(.white)
                    } else {
                        Text("play with me!")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                    Button {
                        isPickerPresented = true
                    } label: {
                        Text("sleepy time 😴")
                            .foregroundStyle(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#d0e4f7"))
                            .cornerRadius(20)
                    }
                    .sheet(isPresented: $isPickerPresented) {
                        PickerView(dogManager: dogManager)
                    }
                    NavigationLink {
                        AppsOverviewView(manager: manager, dogManager: dogManager)
                    } label: {
                        Text("paws off apps 🚫")
                            .foregroundStyle(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#d0e4f7"))
                            .cornerRadius(20)
                    }
                    Button {
                        isEvolutionPresented = true
                    } label: {
                        Text("top dawgs 🏆")
                            .foregroundStyle(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#d0e4f7"))
                            .cornerRadius(20)
                    }
                    .sheet(isPresented: $isEvolutionPresented) {
                        EvolutionView(dogManager: dogManager)
                    }
                    
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isStatsPresented.toggle()
                        } label: {
                            Image(systemName: "pawprint.fill")
                                .imageScale(.large)
                                .symbolRenderingMode(.hierarchical)
                        }
                        .sheet(isPresented: $isStatsPresented) {
                            DogStatsView(dogManager: dogManager)
                        }
                    }
                }
                
                
                .onAppear {
                    if !dogManager.name.isEmpty {
                        isNameFinal = true
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(manager: ShieldManager())
}

