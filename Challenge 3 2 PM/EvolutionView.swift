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
    @State private var isShowingLeaderboard = false
    
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
                isShowingLeaderboard = true
            }
            .buttonStyle(.bordered)
            .disabled(!gcManager.isAuthenticated)
        }
        .onAppear {
            if !gcManager.isAuthenticated {
                GameCenterManager.shared.authenticate()
            }
        }
        .sheet(isPresented: $isShowingLeaderboard) {
            GameCenterLeaderboardView(leaderboardID: leaderboardID)
        }
    }
}

class GameCenterDelegate: NSObject, GKGameCenterControllerDelegate {
    static let shared = GameCenterDelegate()

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}

struct GameCenterLeaderboardView: UIViewControllerRepresentable {
    let leaderboardID: String

    func makeUIViewController(context: Context) -> GKGameCenterViewController {
        // Ensure the player is authenticated before presenting
        if !GKLocalPlayer.local.isAuthenticated {
            GameCenterManager.shared.authenticate()
        }
        let vc = GKGameCenterViewController(leaderboardID: leaderboardID, playerScope: .global, timeScope: .allTime)
        vc.gameCenterDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {
        // No dynamic updates needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, GKGameCenterControllerDelegate {
        func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
            gameCenterViewController.dismiss(animated: true)
        }
    }
}

// MARK: - Preview
#Preview {
    EvolutionView(dogManager: DogManager())
}
