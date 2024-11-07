import SwiftUI
import SceneKit

struct ContainerView: View {
    
    var body: some View {
        NavigationView {
            TabView {
                ContentView()
                    .tabItem {
                        Image(systemName: "party.popper")
                        Text("Tools")
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
