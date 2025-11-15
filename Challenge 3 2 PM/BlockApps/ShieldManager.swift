//
//  AppBlockerView.swift
//  Challenge 3 2 PM
//
//  Created by Anantika Tiwari on 10/11/25.
//

import SwiftUI
import FamilyControls
import ManagedSettings

class ShieldManager: ObservableObject{
    @Published var discouragedSelections = FamilyActivitySelection()
    @Published var blockUntil: Date? = nil
    @Published var isLocked: Bool = false
    
    private let store = ManagedSettingsStore()
    private var timer: Timer?

        init() {
            startTimer()
        }
    
    func shieldActivities(until date: Date?) {
        store.clearAllSettings()
        
        let applications = discouragedSelections.applicationTokens
        let categories = discouragedSelections.categoryTokens
        
        store.shield.applications = applications.isEmpty ? nil: applications
        store.shield.applicationCategories = categories.isEmpty ? nil: .specific(categories)
        store.shield.webDomainCategories = categories.isEmpty ? nil: .specific(categories)
        
        blockUntil = date
        isLocked = true
    }
    
    func unshieldActivities() {
        store.clearAllSettings()
        isLocked = false
        blockUntil = nil
    }
    
    func startTimer() {
            timer?.invalidate()

            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.updateLockState()
            }
        }

        func updateLockState() {
            if let blockUntil = blockUntil {
                if blockUntil > Date() {
                    isLocked = true
                } else {
                    isLocked = false
                    unshieldActivities()
                }
            } else {
                isLocked = false
                unshieldActivities()
            }
        }
}


