import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ToolCard(iconName: "timer", title: "Timer", subtitle: "Set a Timer! (Seconds)") {
                            print("Timer tapped")
                        }
                        ToolCard(iconName: "bag.fill", title: "Random Token", subtitle: "Random token bag filled picker") {
                            print("Random Token tapped")
                        }
                        NavigationLink(destination: Dices()) { // Use Dices as the destination view
                            ToolCard(iconName: "dice.fill", title: "Dice Roller", subtitle: "Roll one or multiple dice!") {}
                        }
                        ToolCard(iconName: "line.3.crossed.swirl.circle", title: "Spin the Wheel", subtitle: "Lore Ipsum Text Generator") {
                            print("Spin the Wheel tapped")
                        }
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
