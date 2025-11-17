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
        .supportedFamilies([
            .systemSmall,
        ])
    }
}

#Preview(as: .systemSmall) {
    DogWidgetExtension()
} timeline: {
    let now = Date()
    let dogLevels = [
        "dog1widget",
        "dog2widget",
        "dog3widget",
        "dog4widget",
        "dog5widget"
    ]
    let entries: [DogEntry] = dogLevels.enumerated().map { index, name in
        DogEntry(
            date: now.addingTimeInterval(Double(index * 60)),
            imageName: name
        )
    }
    // Emit entries directly; do not wrap them in Timeline(...)
    for entry in entries {
        entry
    }
}
