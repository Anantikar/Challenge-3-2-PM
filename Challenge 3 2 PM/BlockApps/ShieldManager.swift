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
    
    private let store = ManagedSettingsStore()
    
    func shieldActivities() {
        store.clearAllSettings()
        
        let applications = discouragedSelections.applicationTokens
        let categories = discouragedSelections.categoryTokens
        
        store.shield.applications = applications.isEmpty ? nil: applications
        store.shield.applicationCategories = categories.isEmpty ? nil: .specific(categories)
        store.shield.webDomainCategories = categories.isEmpty ? nil: .specific(categories)
        
    }
    
    func unshieldActivities() {
        store.clearAllSettings()
    }
}


