//
//  Created by T Krobot on 10/11/25.
//

import SwiftUI
import GameKit


private let leaderboardID: String = "sleepdawg.leaderboard"

struct EvolutionView: View {
    @StateObject private var gcManager = GameCenterManager.shared
    @ObservedObject var dogManager: DogManager
    
    var body: some View {
        VStack(spacing: 20) {
            DogImageView(dogManager: dogManager)
            
            // Game Center status
            if gcManager.isAuthenticated {
                Text("Signed in as \(GKLocalPlayer.local.displayName)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                Text("Not signed in to Game Center")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Button("Sign in to Game Center") {
                    gcManager.authenticateUser()
                }
                .buttonStyle(.bordered)
            }
            
            // Show leaderboard button
            Button("Show Leaderboard") {
                showLeaderboard()
            }
            .buttonStyle(.bordered)
            .disabled(!gcManager.isAuthenticated)
        }
        .padding()
        .onAppear {
            if !gcManager.isAuthenticated {
                gcManager.authenticateUser()
            }
        }
    }
    
    // MARK: - Show Leaderboard
    func showLeaderboard() {
        guard GKLocalPlayer.local.isAuthenticated else {
            print("⚠️ Player not authenticated; cannot show leaderboard.")
            return
        }
        
        // Present asynchronously on the main thread
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.keyWindow?.rootViewController {
                
                let gcVC = GKGameCenterViewController(
                    leaderboardID: leaderboardID,
                    playerScope: .global,
                    timeScope: .allTime
                )
                gcVC.gameCenterDelegate = GameCenterDelegate.shared
                
                rootVC.present(gcVC, animated: true)
            } else {
                print("⚠️ Could not find root view controller.")
            }
        }
    }
}

// MARK: - Game Center Delegate
class GameCenterDelegate: NSObject, GKGameCenterControllerDelegate {
    static let shared = GameCenterDelegate()
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}

// MARK: - Score reporting
func reportScore(_ score: Int) {
    guard GKLocalPlayer.local.isAuthenticated else {
        print("⚠️ Player not authenticated; cannot submit score.")
        return
    }
    
    if #available(iOS 14.0, *) {
        GKLeaderboard.submitScore(
            score,
            context: 0,
            player: GKLocalPlayer.local,
            leaderboardIDs: [leaderboardID]
        ) { error in
            if let error = error {
                print("❌ Error reporting score: \(error.localizedDescription)")
            } else {
                print("✅ Score submitted successfully!")
            }
        }
    } else {
        let legacyScore = GKScore(leaderboardIdentifier: leaderboardID)
        legacyScore.value = Int64(score)
        GKScore.report([legacyScore]) { error in
            if let error = error {
                print("❌ Error reporting score (legacy): \(error.localizedDescription)")
            } else {
                print("✅ Score submitted successfully! (legacy)")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    EvolutionView(dogManager: DogManager())
}
