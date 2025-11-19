//
//  DogWidgetExtension.swift
//  Challenge 3 2 PM
//
//  Created by T Krobot on 17/11/25.
//
import WidgetKit
import SwiftUI

struct DogWidgetExtension: Widget {
    let kind: String = "dog widget extension"
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: DogProvider(),
            content: { DogWidgetView(entry: $0) }
        )
        .configurationDisplayName("dawg")
        .description("dawgg")
        .contentMarginsDisabled()
        .supportedFamilies([
            .systemSmall
        ])
    }
}

#Preview(as: .systemSmall) {
    DogWidgetExtension()
} timeline: {
    let now = Date()
    
    DogEntry(date: now, imageName: "dog1widget")
    DogEntry(date: now.addingTimeInterval(60), imageName: "dog2widget")
    DogEntry(date: now.addingTimeInterval(120), imageName: "dog3widget")
    DogEntry(date: now.addingTimeInterval(180), imageName: "dog4widget")
    DogEntry(date: now.addingTimeInterval(240), imageName: "dog5widget")
}


