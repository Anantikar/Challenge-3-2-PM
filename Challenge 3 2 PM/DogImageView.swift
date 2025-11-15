//
//  DogImageView.swift
//  Challenge 3 2 PM
//
//  Created by T Krobot on 10/11/25.
//

import SwiftUI
enum Emotion: String {
    case happy, sad, standard, dead
}
struct DogImageView: View {
    var level: Int
    var emotion: Emotion
    @State private var isJumping = false
    var body: some View {
        VStack {
            Image("dog\(level)\(emotion.rawValue)")
                .resizable()
                .scaledToFit()
                .offset(y: isJumping ? -35 : 0)
                .animation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0), value: isJumping)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0)) {
                        isJumping = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0)) {
                            isJumping = false
                        }
                    }
                }
        }
    }
}

#Preview {
    DogImageView(level: 1, emotion: .happy)
}
