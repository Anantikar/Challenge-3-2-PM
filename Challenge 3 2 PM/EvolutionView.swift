//
//  EvolutionView.swift
//  Challenge 3 2 PM
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

            // Status / Sign-in button
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
                        GameCenterManager.shared.authenticate()
                    }
                    .buttonStyle(.bordered)
                }

            }

            // Show leaderboard button
            Button("Show Leaderboard") {
                showLeaderboard()
            }
            .buttonStyle(.bordered)
            .disabled(!gcManager.isAuthenticated)
        }
        .onAppear {
            if !gcManager.isAuthenticated {
                GameCenterManager.shared.authenticate()
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

// MARK: - Preview
#Preview {
    EvolutionView(dogManager: DogManager())
}
