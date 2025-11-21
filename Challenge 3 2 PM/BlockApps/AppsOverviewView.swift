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
        NavigationStack {
            ZStack {
                Image("wallpaper")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    if manager.isLocked, let unlockTime = manager.blockUntil {
                        Text("\(dogManager.name) has locked your apps until \(unlockTime.formatted(date: .omitted, time: .shortened))")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .bold()
                    } else {
                        Text("No apps currently locked")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .bold()
                            .padding()
                    }
                    DogImageView(dogManager: dogManager)
                        .foregroundStyle(.white)
                    Text("stop scrolling ruff ruff 🐶")
                        .padding(.top, -30)
                    HStack{
                        NavigationLink("Edit") {
                            BlockerView(
                                manager: manager,
                                wakeUp: $manager.blockUntil
                            )
                        }
                        .disabled(manager.isLocked)
                        .opacity(manager.isLocked ? 0.7 : 1.0)
                        .buttonStyle(.borderedProminent)
                        
                        Button(role:.destructive){
                            showConfirmation.toggle()
                        }label:{
                            Image(systemName: "exclamationmark.triangle")
                            Text("Emergency stop")
                        }
                        .disabled(!manager.isLocked)
                        .opacity(!manager.isLocked ? 0.7 : 1.0)
                    }
                    .padding(.top, 100)
                    Spacer()
                }
                .navigationTitle("Block Apps")
                .foregroundStyle(.white)
                .buttonStyle(.borderedProminent)
            }
        }
        .task{
            do{
                try await center.requestAuthorization(for: .individual)
            }catch{
                print("Failed to get authorization: \(error)")
            }
        }
        .confirmationDialog("100 Hearts gained", isPresented: $manager.awardConfirmationShown, titleVisibility: .hidden){
            Button{
                manager.awardConfirmationShown.toggle()
                dogManager.hearts += 100
            }label: {
                Text("OK")
            }
        }message: {
            Text("Congratulations! \(dogManager.name) has gained 100 hearts!")
        }
        .confirmationDialog("Emergency stop", isPresented: $showConfirmation, titleVisibility: .hidden){
            Button(role: .destructive){
                manager.unshieldActivities()
                showConfirmation.toggle()
                dogManager.hearts -= 50
                manager.wasEmergencyused = true
            }label: {
                Text("Emergency Stop")
            }
        } message: {
            Text("Are you sure you want to stop? \(dogManager.name) will lose 50 hearts.")
        }
    }
}

#Preview {
    AppsOverviewView(manager: ShieldManager(), dogManager: DogManager())
}

