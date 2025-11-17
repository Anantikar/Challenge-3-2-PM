//
//  AppsOverviewView.swift
//  Challenge 3 2 PM
//
//  Created by Anantika Tiwari on 10/11/25.
//

import SwiftUI
import FamilyControls

struct AppsOverviewView: View {
    @ObservedObject var manager: ShieldManager
    let center = AuthorizationCenter.shared
    @ObservedObject var dogManager: DogManager
    @State private var showConfirmation: Bool = false
    var body: some View {
        VStack {
            if manager.isLocked, let unlockTime = manager.blockUntil {
                Text("\(dogManager.name) has locked your apps until \(unlockTime.formatted(date: .omitted, time: .shortened))")
            } else {
                Text("No apps currently locked")
            }
            NavigationLink("Edit") {
                BlockerView(
                    manager: manager,
                    wakeUp: $manager.blockUntil
                )
            }
            .disabled(manager.isLocked)
            .opacity(manager.isLocked ? 0.7 : 1.0)
            
                        
            Button{
                showConfirmation.toggle()
            }label:{
                Image(systemName: "arrow.2.circlepath.circle")
                Text("Emergency stop")
            }
            .disabled(!manager.isLocked)
            .opacity(!manager.isLocked ? 0.7 : 1.0)
        }
        .task{
            do{
                try await center.requestAuthorization(for: .individual)
            }catch{
                print("Failed to get authorization: \(error)")
            }
        }
        .confirmationDialog("Emergency stop", isPresented: $showConfirmation, titleVisibility: .hidden){
            Button(role: .destructive){
                manager.unshieldActivities()
                manager.isLocked = false
                showConfirmation.toggle()
                dogManager.hearts -= 50
            }label: {
                Text("Emergency Stop")
            }
        }message: {
            Text("Are you sure you want to stop? \(dogManager.name) will lose 50 hearts.")
        }
    }
}

#Preview {
    AppsOverviewView(manager: ShieldManager(), dogManager: DogManager())
}
