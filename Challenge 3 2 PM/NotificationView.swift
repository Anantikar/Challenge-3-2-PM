//
//  NotificationView.swift
//  Challenge 3 2 PM
//
//  Created by swiftinsg on 10/11/25.
//

import UserNotifications

func requestNotificationAuthorization() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        if granted {
            print("Notification permission granted.")
        } else {
            print("Notification permission denied.")
        }
    }
}
func scheduleLocalNotification() {
    let content = UNMutableNotificationContent()
    content.title = "Reminder!"
    content.body = "Don't forget your task."
    content.sound = UNNotificationSound.default // Optional: Play default sound

    // Define a trigger (e.g., time-based, calendar-based, or location-based)
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // Fire after 5 seconds, not repeating

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { (error) in
        if let error = error {
            print("Error scheduling notification: \(error.localizedDescription)")
        } else {
            print("Local notification scheduled.")
        }
    }
}
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle notification presentation in the foreground
        completionHandler([.banner, .sound]) // Show banner and play sound
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle user interaction with the notification
        print("User tapped notification with identifier: \(response.notification.request.identifier)")
        completionHandler()
    }
}
