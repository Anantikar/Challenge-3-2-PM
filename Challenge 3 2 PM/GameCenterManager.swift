//
//  GameCenterManager.swift
//  Challenge 3 2 PM
//
//  Created by T Krobot on 10/11/25.
//

import Foundation
import GameKit
import SwiftUI

class GameCenterManager: NSObject, ObservableObject {
    static let shared = GameCenterManager()
    @Published var isAuthenticated = false
    
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let vc = viewController {
                // If Game Center needs to show a login screen, present it
                guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let rootVC = scene.windows.first?.rootViewController else {
                    return
                }
                rootVC.present(vc, animated: true)
            } else if GKLocalPlayer.local.isAuthenticated {
                // Player successfully authenticated
                self.isAuthenticated = true
                print("✅ Player authenticated as \(GKLocalPlayer.local.displayName)")
            } else if let error = error {
                print("❌ Game Center authentication failed: \(error.localizedDescription)")
            } else {
                print("⚠️ Game Center authentication was canceled or not available.")
            }
        }
    }
}
