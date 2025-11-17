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
        "deadDog",
        "sadDog",
        "standardDog",
        "happyDog",
    ]
}
struct DogProvider: TimelineProvider {
    private let dogInfo = Dog()
    private let placeholderEntry = DogEntry(
        date: Date(),
        dogEvolution: ""
    )
    func placeholder(in context: Context) -> DogEntry {
        return placeholderEntry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DogEntry) -> ()) {
        completion(placeholderEntry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DogEntry>) -> Void) {
        let currentDate = Date()
        var entries : [DogEntry] = []
        
        for minuteOffset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let evolution = dogInfo.evolutionList[Int.random(in: 0...dogInfo.evolutionList.count-1)]
            let entry = DogEntry(date: entryDate, dogEvolution: evolution)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        
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
            
            Text(entry.dogEvolution)
                .font(.caption)
        }
        .foregroundStyle(.white)
        .containerBackground(for: .widget){
            Color.cyan
        }
    }
}
