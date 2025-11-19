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
            Button {
                saveTimes()
                scheduleBedtimeReminder()
            } label: {
                Text("Save")
            }
            .padding(.top)
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
    }

    private func loadTimes() {
        let defaults = UserDefaults.standard
        if let savedBedtime = defaults.object(forKey: SleepKeys.bedtime) as? Double {
            bedtime = Date(timeIntervalSince1970: savedBedtime)
        }
    }

    // Schedules next occurrence only; if today's time has passed, schedules for tomorrow.
    private func scheduleBedtimeReminder() {
        let calendar = Calendar.current
        let bedtimeComponents = calendar.dateComponents([.hour, .minute], from: bedtime)
        guard let hour = bedtimeComponents.hour, let minute = bedtimeComponents.minute else { return }

        var todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        todayComponents.hour = hour
        todayComponents.minute = minute

        let targetToday = calendar.date(from: todayComponents) ?? Date()
        let reminderDate = calendar.date(byAdding: .minute, value: -30, to: targetToday) ?? targetToday

        let nextReminderDate: Date
        if reminderDate <= Date() {
            nextReminderDate = calendar.date(byAdding: .day, value: 1, to: reminderDate) ?? reminderDate.addingTimeInterval(86400)
        } else {
            nextReminderDate = reminderDate
        }

        let triggerDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: nextReminderDate)

        let content = UNMutableNotificationContent()
        content.title = "Bedtime soon"
        content.body = "It's 30 minutes before \(dogManager.name.isEmpty ? "bedtime" : "\(dogManager.name)'s bedtime")."
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: NotificationKeys.bedtimeReminderID,
                                            content: content,
                                            trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [NotificationKeys.bedtimeReminderID])
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule bedtime reminder: \(error.localizedDescription)")
            } else {
                print("Scheduled bedtime reminder for \(nextReminderDate)")
            }
        }
    }
}

#Preview {
    PickerView(dogManager: DogManager())
}
