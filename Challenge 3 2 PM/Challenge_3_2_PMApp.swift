//
//  Challenge_3_2_PMApp.swift
//  Challenge 3 2 PM
//
//  Created by Anantika Tiwari on 10/11/25.
//

import SwiftUI

@main
struct Challenge_3_2_PMApp: App {
    @Environment(\.openURL) var openURL
    init() {
        // Authenticate when the app launches
        GameCenterManager.shared.authenticate()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(manager: ShieldManager())
                .onOpenURL { url in
                    print("opened from widget", url)
                }
        }
    }
}
