//
//  widget.swift
//  widget
//
//  Created by T Krobot on 17/11/25.
//

import WidgetKit
import Foundation
import SwiftUI

struct DogEntry: TimelineEntry {
    let date: Date
    let dogEvolution: String
}
struct Dog {
    var evolutionList: [String] = [
        "Dog Evolution 1, Widget",
        "Dog Evolution 2, Widget",
        "Dog Evolution 3, Widget",
        "Dog Evolution 4, Widget",
        "Dog Evolution 5, Widget"
    ]
}
struct DogProvider: TimelineProvider {
    private let dogInfo = Dog()
    private let placeholderEntry = DogEntry(
        date: Date(),
        dogEvolution: "Dog Evolution 1, Widget"
    )
    func placeholder(in context: Context) -> DogEntry {
        return placeholderEntry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DogEntry) -> ()) {
        completion(placeholderEntry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DogEntry>) -> Void) {
        let shared = SharedDogDefaults.shared
        let level = shared.integer(forKey: "level")
        // clamp level to valid range
        let clampedLevel = min(max(level, 0), dogInfo.evolutionList.count-1)
        let evolution = dogInfo.evolutionList[clampedLevel]
        let entry = DogEntry(date: Date(), dogEvolution: evolution)
        let timeline = Timeline(entries: [entry], policy: .never)
        
        completion(timeline)
    }
}
struct DogWidgetView: View {
    var entry: DogProvider.Entry
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("dawg")
            }
            .font(.title3)
            .bold()
            .padding(.bottom, 8)
            
            Image(entry.dogEvolution)
                .resizable()
                .scaledToFit()
        }
        .widgetURL(URL(string: "sleepdawg://openApp"))
        .foregroundStyle(.white)
        .containerBackground(for: .widget){
            Color.cyan
        }
    }
}
