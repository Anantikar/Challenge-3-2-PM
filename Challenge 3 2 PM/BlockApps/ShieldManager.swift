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
    @Published var discouragedSelections = FamilyActivitySelection(){
        didSet { saveSelection() }
    }
    @Published var blockUntil: Date? = nil{
        didSet { saveBlockUntil() }
    }
    @Published var isLocked: Bool = false
    
    @Published var wasEmergencyused: Bool = false
    
    @Published var awardConfirmationShown: Bool = false
    
    @ObservedObject var dogManager = DogManager()
    
    private let store = ManagedSettingsStore()
    private var timer: Timer?
    
    init() {
        loadSelection()
        loadBlockUntil()
        reapplyShieldIfNeeded()
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
    
    private func saveSelection() {
        do {
            let data = try JSONEncoder().encode(discouragedSelections)
            UserDefaults.standard.set(data, forKey: "discouragedSelections")
        } catch {
            print("Failed to save selections: \(error)")
        }
    }
    
    private func loadSelection() {
        guard let data = UserDefaults.standard.data(forKey: "discouragedSelections") else { return }
        if let decoded = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) {
            discouragedSelections = decoded
        }
    }
    
    private func saveBlockUntil() {
        if let date = blockUntil {
            UserDefaults.standard.set(date.timeIntervalSince1970, forKey: "blockUntil")
        } else {
            UserDefaults.standard.removeObject(forKey: "blockUntil")
        }
    }
    
    private func loadBlockUntil() {
        let time = UserDefaults.standard.double(forKey: "blockUntil")
        if time > 0 {
            blockUntil = Date(timeIntervalSince1970: time)
        }
    }
    
    private func reapplyShieldIfNeeded() {
        guard let blockUntil = blockUntil else { return }
        if blockUntil > Date() {
            shieldActivities(until: blockUntil)
        } else {
            unshieldActivities()
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateLockState()
        }
    }
    
    func updateLockState() {
        guard let blockUntil = blockUntil else {
            return
        }
        if blockUntil > Date() {
            isLocked = true
        } else {

            if isLocked == true && wasEmergencyused == false {
                awardConfirmationShown = true
            }

            wasEmergencyused = false
            unshieldActivities()
        }
    }

}
    
