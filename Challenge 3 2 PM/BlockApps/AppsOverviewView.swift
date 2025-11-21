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
    @State private var showAppConfigure: Bool = false
    @State private var wakeUp: Date? = nil
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
                        Text("no apps currently locked")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .bold()
                            .padding()
                    }
                    DogImageView(dogManager: dogManager)
                        .foregroundStyle(.white)
                    Text("stop scrolling ruff ruff 🐶")
                        .padding(.top, -30)
                    Button(role:.destructive){
                        showConfirmation.toggle()
                    }label:{
                        Image(systemName: "exclamationmark.triangle")
                        Text("emergency stop")
                    }
                    .disabled(!manager.isLocked)
                    .opacity(!manager.isLocked ? 0.7 : 1.0)
                    .padding(.top, 100)
                    Spacer()
                }
                .navigationTitle("block Apps")
                .foregroundStyle(.white)
                .tint(.white)
                .buttonStyle(.borderedProminent)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("edit") {
                            showAppConfigure = true
                        }
                        .sheet(isPresented: $showAppConfigure){
                            BlockerView(
                                manager: manager,
                                wakeUp: $wakeUp,
                                showConfig: $showAppConfigure
                            )
                        }
                        .disabled(manager.isLocked)
                        .opacity(manager.isLocked ? 0.7 : 1.0)
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .overlay(alignment: .topTrailing) {
            }
        }
        .task{
            do{
                try await center.requestAuthorization(for: .individual)
            }catch{
                print("Failed to get authorization: \(error)")
            }
        }
        .confirmationDialog("100 hearts gained", isPresented: $manager.awardConfirmationShown, titleVisibility: .hidden){
            Button{
                manager.awardConfirmationShown.toggle()
                dogManager.hearts += 100
            }label: {
                Text("OK")
            }
        }message: {
            Text("congratulations! \(dogManager.name) has gained 100 hearts!")
        }
        .confirmationDialog("emergency stop", isPresented: $showConfirmation, titleVisibility: .hidden){
            Button(role: .destructive){
                manager.unshieldActivities()
                showConfirmation.toggle()
                dogManager.hearts -= 50
                manager.wasEmergencyused = true
            }label: {
                Text("emergency stop")
            }
        } message: {
            Text("are you sure you want to stop? \(dogManager.name) will lose 50 hearts.")
        }
    }
}

#Preview {
    AppsOverviewView(manager: ShieldManager(), dogManager: DogManager())
}

