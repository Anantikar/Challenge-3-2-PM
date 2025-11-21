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
                    HStack{
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

                        Button(role:.destructive){
                            showConfirmation.toggle()
                        }label:{
                            Image(systemName: "exclamationmark.triangle")
                            Text("emergency stop")
                        }
                        .disabled(!manager.isLocked)
                        .opacity(!manager.isLocked ? 0.7 : 1.0)
                    }
                    .padding(.top, 100)
                    Spacer()
                }
                .navigationTitle("block apps")
                .navigationBarTitleDisplayMode(.inline)
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
        .onAppear {
            // Inline title (small) text color to white
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.white
            ]
            // Do NOT change largeTitleTextAttributes, so large titles stay default

            let navBar = UINavigationBar.appearance()
            navBar.standardAppearance = appearance
            navBar.compactAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
        }
        .onDisappear {
            // Restore default to avoid affecting other screens
            let restore = UINavigationBarAppearance()
            restore.configureWithDefaultBackground()

            let navBar = UINavigationBar.appearance()
            navBar.standardAppearance = restore
            navBar.compactAppearance = restore
            navBar.scrollEdgeAppearance = restore
        }
    }
}

#Preview {
    AppsOverviewView(manager: ShieldManager(), dogManager: DogManager())
}

