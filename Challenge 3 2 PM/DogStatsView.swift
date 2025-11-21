//
//  DogStatsView.swift
//  Challenge 3 2 PM
//
//  Created by Anantika Tiwari on 17/11/25.
//

import SwiftUI

struct DogStatsView: View {
    
    @ObservedObject var dogManager:DogManager
    
    var body: some View {
        NavigationStack{
            VStack{
                DogImageView(dogManager: dogManager)
                List {
                    Text("**level:** \(dogManager.level)")
                    Text("**emotion:** \(dogManager.emotion.rawValue)")
                    Text("**total hearts:** \(dogManager.hearts)")
                    Text("**hearts till evolution:** \(dogManager.heartsToNextEvolution())❤️")
                }
                .listStyle(.plain)
            }
            .navigationTitle("\(dogManager.name)'s stats")
        }
        .padding()
    }
}

#Preview {
    DogStatsView(dogManager: DogManager())
}
