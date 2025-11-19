//
//  PickerView.swift
//  Challenge 3 2 PM
//
//  Created by swiftinsg on 10/11/25.
//
import SwiftUI
import UserNotifications

private enum SleepKeys {
    static let bedtime = "sleep_bedtime"
    static let wakeup = "sleep_wakeup"
}

private enum NotificationKeys {
    static let bedtimeReminderID = "sleep_bedtime_30min_reminder"
}

struct PickerView: View {
    @State private var bedtime = Date.now
    @State private var wakeup = Date.now
    @State private var inputText: String = ""
    @ObservedObject var dogManager: DogManager

    var body: some View {
        VStack {
            DogImageView(dogManager: dogManager)

            HStack {
                Text("When does \(dogManager.name) wanna sleep")
                    .font(.headline)
                    .padding()
                DatePicker("", selection: $bedtime, displayedComponents: .hourAndMinute)
                    .padding()
            }
            HStack {
                Text("When does \(dogManager.name) wanna wake up")
                    .font(.headline)
                    .padding()
                DatePicker("", selection: $wakeup, displayedComponents: .hourAndMinute)
                    .padding()
            }

            Button {
                saveTimes()
                scheduleBedtimeReminder()
            } label: {
                Text("Save")
            }
        }
        .onAppear {
            loadTimes()
            // Ask for notifications permission
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("Notification permission error: \(error.localizedDescription)")
                } else {
                    print("Notification permission granted? \(granted)")
                }
            }
        }
    }

    private func saveTimes() {
        let defaults = UserDefaults.standard
        defaults.set(bedtime.timeIntervalSince1970, forKey: SleepKeys.bedtime)
        defaults.set(wakeup.timeIntervalSince1970, forKey: SleepKeys.wakeup)
    }

    private func loadTimes() {
        let defaults = UserDefaults.standard
        if let savedBedtime = defaults.object(forKey: SleepKeys.bedtime) as? Double {
            bedtime = Date(timeIntervalSince1970: savedBedtime)
        }
        if let savedWakeup = defaults.object(forKey: SleepKeys.wakeup) as? Double {
            wakeup = Date(timeIntervalSince1970: savedWakeup)
        }
    }

    // MARK: - Notifications

    private func scheduleBedtimeReminder() {
        // Build next occurrence of bedtime today/tomorrow with only hour/minute components
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: bedtime)

        guard let hour = components.hour, let minute = components.minute else {
            return
        }

        // 30 minutes before bedtime
        var beforeComponents = DateComponents()
        beforeComponents.hour = hour
        beforeComponents.minute = minute

        // Convert to a Date today, subtract 30 minutes, then extract hour/minute again for repeating trigger
        let today = Date()
        var todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        todayComponents.hour = hour
        todayComponents.minute = minute

        let targetToday = calendar.date(from: todayComponents) ?? today
        let reminderDate = calendar.date(byAdding: .minute, value: -30, to: targetToday) ?? targetToday

        var reminderTimeComponents = calendar.dateComponents([.hour, .minute], from: reminderDate)
        // If subtracting 30 min crossed to previous day, reminderTimeComponents will still be valid for repeating daily

        // Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Bedtime soon"
        content.body = "It's 30 minutes before \(dogManager.name.isEmpty ? "bedtime" : "\(dogManager.name)'s bedtime")."
        content.sound = .default

        // Repeating daily at that time
        let trigger = UNCalendarNotificationTrigger(dateMatching: reminderTimeComponents, repeats: true)

        // Replace any existing request with same identifier
        let request = UNNotificationRequest(identifier: NotificationKeys.bedtimeReminderID,
                                            content: content,
                                            trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [NotificationKeys.bedtimeReminderID])
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule bedtime reminder: \(error.localizedDescription)")
            } else {
                print("Scheduled bedtime reminder at \(String(format: "%02d:%02d", reminderTimeComponents.hour ?? 0, reminderTimeComponents.minute ?? 0)) daily.")
            }
        }
    }
}

#Preview {
    PickerView(dogManager: DogManager())
}
