////
////  GameCenterManager.swift
////  Challenge 3 2 PM
////
////  Created by T Krobot on 10/11/25.
////
//
//import Foundation
//import GameKit
//import SwiftUI
//
//class GameCenterManager: NSObject, ObservableObject {
//    static let shared = GameCenterManager()
//    @Published var isAuthenticated = false
//
//    func authenticateUser() {
//        GKLocalPlayer.local.authenticateHandler = { viewController, error in
//            if let vc = viewController {
//                // If Game Center needs to show a login screen, present it
//                guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                      let rootVC = scene.windows.first?.rootViewController else {
//                    return
//                }
//                rootVC.present(vc, animated: true)
//            } else if GKLocalPlayer.local.isAuthenticated {
//                // Player successfully authenticated
//                self.isAuthenticated = true
//                print("✅ Player authenticated as \(GKLocalPlayer.local.displayName)")
//            } else if let error = error {
//                print("❌ Game Center authentication failed: \(error.localizedDescription)")
//            } else {
//                print("⚠️ Game Center authentication was canceled or not available.")
//            }
//        }
//    }
//}

// authentication
import GameKit

class GameCenterManager: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    static let shared = GameCenterManager()
    private override init() {
        super.init()
    }
    func authenticate() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // presenting game center login screen
                guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let root = scene.windows.first?.rootViewController else {
                    return
                }
                root.present(viewController, animated: true)
            } else if GKLocalPlayer.local.isAuthenticated {
                self.isAuthenticated = true
                print("✅ Player authenticated as \(GKLocalPlayer.local.displayName)")
            } else if let error = error {
                print("GC Error: \(error.localizedDescription)")
            }
        }
    }
    func submitHeartsToLeaderboard(_ hearts: Int) {
        let score = GKScore(leaderboardIdentifier: "hearts_leaderboard")
        score.value = Int64(hearts)
        GKScore.report([score]) { error in
            if let error = error {
                print("Submit error: \(error.localizedDescription)")
            } else {
                print("Score submitted successfully: \(hearts)")
            }
        }
    }
}
