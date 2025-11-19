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
            Text("Level: \(dogManager.level)")
            Text("Emotion: \(dogManager.emotion.rawValue.capitalized)")
            Text("Total hearts: \(dogManager.hearts)")
            Text("Number of hearts till evolution:")
            Text("\(dogManager.heartsToNextEvolution())❤️")
        }
        .padding()
    }
}

#Preview {
    DogStatsView(dogManager: DogManager())
}
