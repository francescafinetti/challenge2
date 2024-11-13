import SwiftUI

@main
struct LudiKitApp: App {
    @StateObject private var gameManager = GameManager()
    
    var body: some Scene {
        WindowGroup {
            ContainerView()
                .environmentObject(gameManager)
        }
    }
}
