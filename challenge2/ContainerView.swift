import SwiftUI



struct ContentView: View {
    @Binding var isRolling: Bool
    @Binding var diceCount: Int
    
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
                        NavigationLink(destination: Dices()) { 
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

struct ContentView_Previews: PreviewProvider {
    @State static var isRolling = false
    @State static var diceCount = 1
    
    static var previews: some View {
        ContentView(isRolling: $isRolling, diceCount: $diceCount)
    }
}
