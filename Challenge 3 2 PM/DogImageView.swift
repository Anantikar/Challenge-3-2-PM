//
//  DogImageView.swift
//  Challenge 3 2 PM
//
//  Created by T Krobot on 10/11/25.
//

import SwiftUI
enum Emotion: String {
    case happy, sad, angry, calm
}
struct DogImageView: View {
    var level: Int
    var emotion: Emotion
    var body: some View {
        VStack {
            Image("dog\(level)\(emotion.rawValue)")
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    DogImageView(level: 1, emotion: .happy)
}
