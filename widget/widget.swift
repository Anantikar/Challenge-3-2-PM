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
    let imageName: String
}
struct Dog {
    var evolutionList: [String] = [
        "dog1dog",
        "dog2dog",
        "dog3dog",
        "dog4dog",
        "dog5dog"
    ]
}
struct DogProvider: TimelineProvider {
    private let dogInfo = Dog()
    private let placeholderEntry = DogEntry(
        date: Date(),
        imageName: "dog1dog"
    )
    func placeholder(in context: Context) -> DogEntry {
        return placeholderEntry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DogEntry) -> ()) {
        completion(placeholderEntry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DogEntry>) -> Void) {
        let shared = SharedDogDefaults.shared
        var level = shared.integer(forKey: "level")
        // clamp level to valid range
        level = level > 0 ? level - 1 : level
        let clampedLevel = min(max(level, 0), dogInfo.evolutionList.count-1)
        let imageName = dogInfo.evolutionList[clampedLevel]
        let entry = DogEntry(date: Date(), imageName: imageName)
        let timeline = Timeline(entries: [entry], policy: .never)
        
        completion(timeline)
    }
}

struct DogWidgetView: View {
    var entry: DogProvider.Entry
    var body: some View {
        VStack(alignment: .leading) {
            Image(entry.imageName)
                .resizable()
                .scaledToFit()
        }
        .widgetURL(URL(string: "sleepdawg://openApp"))
        .containerBackground(for: .widget) {
            .thinMaterial
        }
    }
}
