import SwiftUI

// ciao
struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        Text("Tools")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading, 25)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            NavigationLink(destination: TimerView()) {
                                ToolCard(iconName: "timer", title: "Timer", subtitle: "Set a Timer!")
                            }
                            ToolCard(iconName: "bag.fill", title: "Random Token", subtitle: "random token bag filled picker")
                            
                            NavigationLink(destination: Dices()) {
                                ToolCard(iconName: "dice.fill", title: "Dice Roller", subtitle: "Roll one or multiple dices!")
                            }
                            NavigationLink(destination: Wheel()) {
                                ToolCard(iconName: "line.3.crossed.swirl.circle", title: "Spin the Wheel", subtitle: "Lore Ipsum Text Generator")
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
