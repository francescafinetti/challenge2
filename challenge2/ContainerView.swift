import SwiftUI
import SceneKit

struct ContainerView: View {
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        NavigationView {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Tools", systemImage: "party.popper")
                    }
                
                RankingView_()
                    .tabItem {
                        Label("Rankings", systemImage: "list.number")
                    }
                
                RecentGamesView()
                    .tabItem {
                        Label("Games History", systemImage: "clock")
                    }
            }
        }
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
            .environmentObject(GameManager())
    }
}

