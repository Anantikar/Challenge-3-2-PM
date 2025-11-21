//
//  Challenge_3_2_PMApp.swift
//  Challenge 3 2 PM
//
//  Created by Anantika Tiwari on 10/11/25.
//

import SwiftUI
import UserNotifications

@main
struct Challenge_3_2_PMApp: App {
    @Environment(\.openURL) var openURL
    private let notificationDelegate = NotificationDelegate()

    init() {
        GameCenterManager.shared.authenticate()

        UNUserNotificationCenter.current().delegate = notificationDelegate
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification auth error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted? \(granted)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(manager: ShieldManager())
                .preferredColorScheme(.dark)
                .onOpenURL { url in
                    print("opened from widget", url)
                }
        }
    }
}
