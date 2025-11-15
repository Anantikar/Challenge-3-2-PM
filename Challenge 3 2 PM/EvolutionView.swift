//
//  Created by T Krobot on 10/11/25.
//

import SwiftUI
import GameKit

// Replace this with your actual Leaderboard ID from App Store Connect
private let leaderboardID: String = "sleepdawg.leaderboard"

struct EvolutionView: View {
    @StateObject private var gcManager = GameCenterManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Group {
                if gcManager.isAuthenticated {
                    Text("Signed in as \(GKLocalPlayer.local.displayName)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Not signed in to Game Center")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Button("Sign in to Game Center") {
                        GameCenterManager.shared.authenticateUser()
                    }
                    .buttonStyle(.bordered)
                }
            }
            Button("Show Leaderboard") {
                showLeaderboard()
            }
            .buttonStyle(.bordered)
            .disabled(!gcManager.isAuthenticated)
        }
        .onAppear {
            if !gcManager.isAuthenticated {
                GameCenterManager.shared.authenticateUser()
            }
        }
    }
}

// Use a String for the leaderboard identifier as required by GameKit

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

func showLeaderboard() {
    guard GKLocalPlayer.local.isAuthenticated else {
        print("⚠️ Player not authenticated; cannot show leaderboard.")
        return
    }
    
    let gcVC = GKGameCenterViewController(
        leaderboardID: leaderboardID,
        playerScope: .global,
        timeScope: .allTime
    )
    gcVC.gameCenterDelegate = GameCenterDelegate.shared
    
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let rootVC = scene.windows.first?.rootViewController {
        rootVC.present(gcVC, animated: true)
    } else {
        print("⚠️ Could not find root view controller.")
    }
}

class GameCenterDelegate: NSObject, GKGameCenterControllerDelegate {
    static let shared = GameCenterDelegate()
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}
