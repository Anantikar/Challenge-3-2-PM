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
    static let bedtimeReminder30MinID = "sleep_bedtime_30min_reminder"
    static let bedtimeNoMeal2HrID = "sleep_bedtime_no_meal_2hr"
    static let bedtimeNoScreens1HrID = "sleep_bedtime_no_screens_1hr"
}

struct PickerView: View {
    @Environment(\.presentationMode) private var
    presentationMode: Binding<PresentationMode>
    @State private var bedtime = Date.now
    @State private var wakeup = Date.now
    @State private var inputText: String = ""
    @ObservedObject var dogManager: DogManager
    
    var body: some View {
        NavigationStack {
            VStack {
                DogImageView(dogManager: dogManager)
                Text("notifications sent based on your chosen bedtime")
                HStack {
                    Text("when does \(dogManager.name) wanna sleep")
                        .font(.headline)
                        .padding()
                    DatePicker("", selection: $bedtime, displayedComponents: .hourAndMinute)
                        .padding()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            saveTimes()
                            scheduleBedtimeReminder()
                            schedulePreBedReminders()
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "checkmark.circle")
                        }
                    }
                }
                
                .padding(.top)
            }
        }
        .onAppear {
            loadTimes()
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
        
        let request = UNNotificationRequest(identifier: NotificationKeys.bedtimeReminder30MinID,
                                            content: content,
                                            trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [NotificationKeys.bedtimeReminder30MinID])
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule bedtime reminder: \(error.localizedDescription)")
            } else {
                print("Scheduled bedtime reminder for \(nextReminderDate)")
            }
        }
    }
    
    // Schedules two additional reminders relative to bedtime: -2h and -1h. If the time has passed today, schedules for tomorrow.
    private func schedulePreBedReminders() {
        let calendar = Calendar.current
        let bedtimeComponents = calendar.dateComponents([.hour, .minute], from: bedtime)
        guard let hour = bedtimeComponents.hour, let minute = bedtimeComponents.minute else { return }
        
        var todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        todayComponents.hour = hour
        todayComponents.minute = minute
        
        let targetToday = calendar.date(from: todayComponents) ?? Date()
        
        // Define the reminders we want to schedule
        struct ReminderSpec {
            let offsetMinutes: Int
            let id: String
            let title: String
            let body: String
        }
        
        let dogNamePortion = dogManager.name.isEmpty ? "bedtime" : "\(dogManager.name)'s bedtime"
        
        let reminders: [ReminderSpec] = [
            ReminderSpec(offsetMinutes: -120,
                         id: NotificationKeys.bedtimeNoMeal2HrID,
                         title: "2 hours before bed",
                         body: "Avoid full meals and strenuous exercise before \(dogNamePortion)."),
            ReminderSpec(offsetMinutes: -60,
                         id: NotificationKeys.bedtimeNoScreens1HrID,
                         title: "1 hour before bed",
                         body: "Avoid screens before \(dogNamePortion).")
        ]
        
        let center = UNUserNotificationCenter.current()
        
        for spec in reminders {
            let candidateDate = calendar.date(byAdding: .minute, value: spec.offsetMinutes, to: targetToday) ?? targetToday
            let nextDate: Date
            if candidateDate <= Date() {
                nextDate = calendar.date(byAdding: .day, value: 1, to: candidateDate) ?? candidateDate.addingTimeInterval(86400)
            } else {
                nextDate = candidateDate
            }
            
            let triggerDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: nextDate)
            
            let content = UNMutableNotificationContent()
            content.title = spec.title
            content.body = spec.body
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: spec.id, content: content, trigger: trigger)
            
            center.removePendingNotificationRequests(withIdentifiers: [spec.id])
            center.add(request) { error in
                if let error = error {
                    print("Failed to schedule reminder (\(spec.id)): \(error.localizedDescription)")
                } else {
                    print("Scheduled reminder (\(spec.id)) for \(nextDate)")
                }
            }
        }
    }
}

#Preview {
    PickerView(dogManager: DogManager())
}
