import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Tools")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading, 25) // Adjust the padding to move title right
                        .frame(maxWidth: .infinity, alignment: .leading)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        NavigationLink(destination: TimerView()) {
                            ToolCard(iconName: "timer", title: "Timer", subtitle: "Set a Timer!")
                        }
                        ToolCard(iconName: "bag.fill", title: "Random Token", subtitle: "random token bag filled picker")
                        
                        NavigationLink(destination: Dices()) {
                            ToolCard(iconName: "dice.fill", title: "Dice Roller", subtitle: "Roll one of multiple dices!")
                        }
                        
                        ToolCard(iconName: "line.3.crossed.swirl.circle", title: "Spin the Wheel", subtitle: "Lore Ipsum Text Generator")
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color(.systemGray6))
            .navigationBarTitleDisplayMode(.inline) // Keep inline title mode for custom text title
        }
    }
}

#Preview {
    ContentView()
}
