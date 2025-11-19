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
        VStack{
            Text("Here is how \(dogManager.name) is doing")
                .bold()
                .font(.largeTitle)
            DogImageView(dogManager: dogManager)
            List {
                Text("**Level:** \(dogManager.level)")
                Text("**Emotion:** \(dogManager.emotion.rawValue.capitalized)")
                Text("**Total hearts:** \(dogManager.hearts)")
                Text("**hearts till evolution:** \(dogManager.heartsToNextEvolution())❤️")
            }
            .listStyle(.plain)
        }
        .padding()
    }
}

#Preview {
    DogStatsView(dogManager: DogManager())
}
