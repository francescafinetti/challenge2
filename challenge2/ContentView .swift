import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ToolCard(iconName: "timer", title: "Timer", subtitle: "Set a Timer! (Seconds)")
                        ToolCard(iconName: "bag.fill", title: "Random Token", subtitle: "random token bag filled picker")
                        ToolCard(iconName: "dice.fill", title: "Dice Roller", subtitle: "Roll one of multiple dices!")
                        ToolCard(iconName: "line.3.crossed.swirl.circle", title: "Spin the Wheel", subtitle: "Lore Ipsum Text Generator")
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Tools")
            .background(Color(.systemGray6))
        }

    }
}

#Preview {
    ContentView()
}
