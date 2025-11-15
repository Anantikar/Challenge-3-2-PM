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
    @State var dogName = ""
    var body: some View {
        VStack {
            if manager.isLocked, let unlockTime = manager.blockUntil {
                Text("Apps locked until \(unlockTime.formatted(date: .omitted, time: .shortened))")
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
            .opacity(manager.isLocked ? 0.4 : 1.0)
            
                        
            Button{
                manager.unshieldActivities()
                manager.isLocked = false
            }label:{
                Image(systemName: "arrow.2.circlepath.circle")
                Text("Emergency stop")
            }
        }
        .task{
            do{
                try await center.requestAuthorization(for: .individual)
            }catch{
                print("Failed to get authorization: \(error)")
            }
        }
    }
}

#Preview {
    AppsOverviewView(manager: ShieldManager(),dogName: "")
}
