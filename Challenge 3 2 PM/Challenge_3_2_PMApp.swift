//
//  Challenge_3_2_PMApp.swift
//  Challenge 3 2 PM
//
//  Created by Anantika Tiwari on 10/11/25.
//

import SwiftUI
import SwiftData

@main
struct Challenge_3_2_PMApp: App {
    @Environment(\.openURL) var openURL
    init() {
        // Authenticate when the app launches
        GameCenterManager.shared.authenticateUser()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(manager: ShieldManager())
                .onOpenURL { url in
                    print("opened from widget", url)
                }
        }
        .modelContainer(for: DogManager.self)
    }
}
