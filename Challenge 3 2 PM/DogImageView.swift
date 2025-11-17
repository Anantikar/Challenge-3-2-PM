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
    @ObservedObject var heartManager = HeartManager.shared
    @State private var isJumping = false
    var body: some View {
        VStack {
            Image("dog\(heartManager.level)\(heartManager.emotion.rawValue)")
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

class HeartManager: ObservableObject { // class is like a blueprint
    static let shared = HeartManager() //
    @Published var totalHearts: Int
    @Published var dailyHearts: Int
    var hoursSpent: Double
    var level: Int
    var emotion: Emotion
    
    init(totalHearts: Int = 0, dailyHearts: Int = 0, hoursSpent: Double = 0, level: Int = 1, emotion: Emotion = .happy) {
        self.totalHearts = totalHearts
        self.dailyHearts = dailyHearts
        self.hoursSpent = hoursSpent
        self.level = level
        self.emotion = emotion
    }
    // calculate hearts based on hours spent
    func calcHearts() -> Int {
        let maxHearts = 50
        let heartsDeducted = Int(hoursSpent * 10)
        let earned = max(maxHearts - heartsDeducted, 0)
        return earned
    }
    func updateHearts() {
        let earned = calcHearts()
        dailyHearts = earned
        totalHearts += earned
    }
    func updateLevel() {
        if totalHearts <= 100 {
            level = 1
        } else if totalHearts <= 200 {
            level = 2
        } else if totalHearts <= 300 {
            level = 3
        } else if totalHearts <= 400 {
            level = 4
        } else {
            level = 5
        }
    }
    func updateEmotion() {
        if dailyHearts <= 10 {
            emotion = .sad
        } else if dailyHearts <= 35 {
            emotion = .standard
        } else {
            emotion = .happy
        }
    }
}
#Preview {
    DogImageView()
}
