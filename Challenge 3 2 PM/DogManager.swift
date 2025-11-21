//
//  DogManager.swift
//  Challenge 3 2 PM
//
//  Created by Anantika Tiwari on 17/11/25.
//


import WidgetKit
enum Emotion: String {
    case happy, sad, chill, dead
}

class DogManager : ObservableObject{
    @Published var emotion: Emotion{
        didSet { save() }
    }
    @Published var level: Int{
        didSet { save() }
    }
    @Published var hearts: Int{
        didSet{
            save()
            evolve()
            saveToSharedDefaults()
            GameCenterManager.shared.submitHeartsToLeaderboard(hearts)
        }
    }
    @Published var name: String{
        didSet { save() }
    }
    
    init() {
        let hasLaunchedBefore =
            UserDefaults.standard.object(forKey: "dog_hearts") != nil ||
            UserDefaults.standard.object(forKey: "dog_level") != nil ||
            UserDefaults.standard.object(forKey: "dog_emotion") != nil ||
            UserDefaults.standard.object(forKey: "dog_name") != nil
        
        if hasLaunchedBefore {
            self.emotion = Emotion(rawValue: UserDefaults.standard.string(forKey: "dog_emotion") ?? "standard") ?? .chill
            self.level = UserDefaults.standard.integer(forKey: "dog_level")
            self.hearts = UserDefaults.standard.integer(forKey: "dog_hearts")
            self.name = UserDefaults.standard.string(forKey: "dog_name") ?? ""
        } else {
            self.hearts = 450
            self.emotion = .sad
            self.level = 1
            self.name = ""
        }
        evolve()
        save()
        saveToSharedDefaults()
    }
    
    private func save() {
        UserDefaults.standard.set(emotion.rawValue, forKey: "dog_emotion")
        UserDefaults.standard.set(level, forKey: "dog_level")
        UserDefaults.standard.set(hearts, forKey: "dog_hearts")
        UserDefaults.standard.set(name, forKey: "dog_name")
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
        
        (1000, .chill, 1),
        (1150, .chill, 2),
        (1300, .chill, 3),
        (1450, .chill, 4),
        (1600, .chill, 5),
        
        (1800, .happy, 1),
        (2000, .happy, 2),
        (2200, .happy, 3),
        (2400, .happy, 4),
        (2600, .happy, 5)
    ]
    
    func evolve() {
        for stage in stages.reversed() {
            if hearts >= stage.minHearts && hearts >= 0 {
                emotion = stage.emotion
                level = stage.level
                return
            } else if hearts < 0 {
                emotion = .dead
                level = 1
            }
        }
        emotion = .sad
        level = 1
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
        WidgetCenter.shared.reloadAllTimelines()
    }
}
