//
//  DogImageView.swift
//  Challenge 3 2 PM
//
//  Created by T Krobot on 10/11/25.
//

import SwiftUI

struct DogImageView: View {
    @State private var isJumping = false
    @Bindable var dogManager: DogManager
    var body: some View {
        VStack {
            Image("dog\(dogManager.level)\(dogManager.emotion.rawValue)")
                .resizable()
                .scaledToFit()
                .offset(y: isJumping ? -25 : 0)
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
    DogImageView(dogManager: DogManager())
}
