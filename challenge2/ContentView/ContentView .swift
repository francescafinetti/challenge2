import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.white, .accentColor.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        
                        Spacer()
                        Text("Tools")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading, 25)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            NavigationLink(destination: TimerView()) {
                                ToolCard(iconName: "hourglass", title: "Timer", subtitle: "Set a Timer!")
                            }
                            NavigationLink(destination: RandomTokenView()) {
                                ToolCard(iconName: "blue_token", title: "Random Token", subtitle: "Create a bag of tokens and draw them!")
                            }
                            
                            NavigationLink(destination: Dices()) {
                                ToolCard(iconName: "dice", title: "Dice Roller", subtitle: "Roll one or multiple dices!")
                            }
                            NavigationLink(destination: Wheel()) {
                                ToolCard(iconName: "wheel1", title: "Random Picker", subtitle: "Insert players and select randomly!")
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
