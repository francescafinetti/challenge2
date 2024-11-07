import SwiftUI
import SceneKit

struct ContainerView: View {
    
    var body: some View {
        NavigationView {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Tools", systemImage: "party.popper")
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
    }
}
