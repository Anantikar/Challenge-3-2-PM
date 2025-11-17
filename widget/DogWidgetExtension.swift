//
//  DogWidgetExtension.swift
//  Challenge 3 2 PM
//
//  Created by T Krobot on 17/11/25.
//
import WidgetKit
import SwiftUI
@main
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
    DogEntry(date: .now, dogEvolution: "deadDog")
    DogEntry(date: .now + 1, dogEvolution: "sadDog")
}
