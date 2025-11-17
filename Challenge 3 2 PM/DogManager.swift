//
//  DogManager.swift
//  Challenge 3 2 PM
//
//  Created by Anantika Tiwari on 17/11/25.
//

import SwiftUI
enum Emotion: String {
    case happy, sad, standard, dead
}
class DogManager : ObservableObject{
    @Published var emotion: Emotion
    @Published var level: Int
    @Published var hearts: Int{
        didSet{
            evolve()
            saveToSharedDefaults()
        }
    }
    @Published var name: String
    
    init(emotion: Emotion = .dead, level: Int = 1, hearts: Int = 0, name: String = "") {
        self.emotion = emotion
        self.level = level
        self.hearts = hearts
        self.name = name
        
    }
    
    private let stages: [(minHearts: Int, emotion: Emotion, level: Int)] = [
        (0, .dead, 1),
        (50, .dead, 2),
        (100, .dead, 3),
        (200, .dead, 4),
        (300, .dead, 5),
        
        (450, .sad, 1),
        (550, .sad, 2),
        (650, .sad, 3),
        (750, .sad, 4),
        (850, .sad, 5),
        
        (1000, .standard, 1),
        (1150, .standard, 2),
        (1300, .standard, 3),
        (1450, .standard, 4),
        (1600, .standard, 5),
        
        (1800, .happy, 1),
        (2000, .happy, 2),
        (2200, .happy, 3),
        (2400, .happy, 4),
        (2600, .happy, 5)
    ]
    
    func evolve() {
        for stage in stages.reversed() {
            if hearts >= stage.minHearts {
                emotion = stage.emotion
                level = stage.level
                return
            }
        }
    }
    
    func heartsToNextEvolution() -> Int {
        for stage in stages {
            if hearts < stage.minHearts {
                let noOfHeartsToNextLevel = stage.minHearts - hearts
                return noOfHeartsToNextLevel
            }
        }
        return 0 
    }
    
    func saveToSharedDefaults() {
        let defaults = SharedDogDefaults.shared
        defaults.set(emotion.rawValue, forKey: "emotion")
        defaults.set(level, forKey: "level")
        defaults.set(hearts, forKey: "hearts")
        defaults.set(name, forKey: "name")
    }
}

