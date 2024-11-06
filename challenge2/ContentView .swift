import SwiftUI

struct tools1: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ToolCard(iconName: "timer", title: "Timer", subtitle: "Set a Timer!")
                        ToolCard(iconName: "bag.fill", title: "Random Token", subtitle: "Create a bag filled with random tokens!")
                        ToolCard(iconName: "dice.fill", title: "Dice Roller", subtitle: "Roll one of multiple dices!")
                        ToolCard(iconName: "line.3.crossed.swirl.circle", title: "Spin the Wheel", subtitle: "-")
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
    tools1()
}
