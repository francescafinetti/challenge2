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
                    .environment(\.symbolVariants, .fill) // Makes active tab icon filled
                
                RecentGamesView()
                    .tabItem {
                        Label("Recent Games", systemImage: "clock")
                    }
                    .environment(\.symbolVariants, .fill) // Makes active tab icon filled
            }
        }
    }
}
struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
