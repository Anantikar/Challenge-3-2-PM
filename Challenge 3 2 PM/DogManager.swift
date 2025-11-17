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
        }
    }
    @Published var name: String
    
    init(emotion: Emotion = .dead, level: Int = 1, hearts: Int = 0, name: String = "") {
        self.emotion = emotion
        self.level = level
        self.hearts = hearts
        self.name = name
        
    }
    
    func evolve(){
        if hearts < 50 {
            emotion = .dead
            level = 1
        } else if hearts>=50 && hearts<100 {
            emotion = .dead
            level = 2
        } else if hearts>=100 && hearts<200 {
            emotion = .dead
            level = 3
        } else if hearts>=200 && hearts<300 {
            emotion = .dead
            level = 4
        } else if hearts>=300 && hearts<450 {
            emotion = .dead
            level = 5
        } else if hearts>=450 && hearts<550 {
            emotion = .sad
            level = 1
        } else if hearts>=550 && hearts<650 {
            emotion = .sad
            level = 2
        } else if hearts>=650 && hearts<750 {
            emotion = .sad
            level = 3
        } else if hearts>=750 && hearts<850 {
            emotion = .sad
            level = 4
        } else if hearts>=850 && hearts<1000{
            emotion = .sad
            level = 5
        } else if hearts>=1000 && hearts<1150{
            emotion = .standard
            level = 1
        } else if hearts>=1150 && hearts<1300{
            emotion = .standard
            level = 2
        } else if hearts>=1300 && hearts<1450{
            emotion = .standard
            level = 3
        } else if hearts>=1450 && hearts<1600{
            emotion = .standard
            level = 4
        } else if hearts>=1600 && hearts<1800{
            emotion = .standard
            level = 5
        } else if hearts>=1800 && hearts<2000{
            emotion = .happy
            level = 1
        } else if hearts>=2000 && hearts<2200{
            emotion = .happy
            level = 2
        } else if hearts>=2200 && hearts<2400{
            emotion = .happy
            level = 3
        } else if hearts>=2400 && hearts<2600{
            emotion = .happy
            level = 4
        } else if hearts>=2600{
            emotion = .happy
            level = 5
        }
    }
}

