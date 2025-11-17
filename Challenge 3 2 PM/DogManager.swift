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
    @Published var hearts: Int
    @Published var name: String
    
    init(emotion: Emotion = .standard, level: Int = 1, hearts: Int = 10, name: String = "") {
        self.emotion = emotion
        self.level = level
        self.hearts = hearts
        self.name = name
        
    }
    
    func evolve(){
        //
    }
}

