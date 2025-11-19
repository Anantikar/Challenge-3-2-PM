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
