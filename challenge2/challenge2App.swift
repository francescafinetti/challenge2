import SwiftUI

@main
struct challenge2App: App {
    @StateObject private var gameManager = GameManager()
    
    var body: some Scene {
        WindowGroup {
            ContainerView()
                .environmentObject(gameManager)
        }
    }
}
