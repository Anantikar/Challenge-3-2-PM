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
        NavigationStack {
            VStack(spacing: 20) {
                DogImageView(dogManager: dogManager)
                Text("ruff ruff! be the best dawg of them all!")
                    .font(.caption)
                Group {
                    if gcManager.isAuthenticated {
                        Text("signed in as \(GKLocalPlayer.local.displayName)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("not signed in to game center")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Button("sign in to game center") {
                            GameCenterManager.shared.authenticate()
                        }
                        .buttonStyle(.bordered)
                    }
                    
                }
                Button("show leaderboard") {
                    isShowingLeaderboard = true
                }
                .buttonStyle(.bordered)
                .disabled(!gcManager.isAuthenticated)
            }
            .navigationTitle("leaderboard")
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
        if !GKLocalPlayer.local.isAuthenticated {
            GameCenterManager.shared.authenticate()
        }
        let vc = GKGameCenterViewController(leaderboardID: leaderboardID, playerScope: .global, timeScope: .allTime)
        vc.gameCenterDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {
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
#Preview {
    EvolutionView(dogManager: DogManager())
}
