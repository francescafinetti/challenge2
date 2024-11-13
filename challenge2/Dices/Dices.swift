import SwiftUI
import SceneKit

struct Dices: View {
    @State private var isRolling = false
    @State private var diceCount = 1

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.white.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            
            VStack {
                Text("Roll the Dices")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .scaleEffect(isRolling ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isRolling)

                DiceView(isRolling: $isRolling, diceCount: $diceCount)
                    .frame(width: 500, height: 500)
                    .padding()

                HStack {
                    Button(action: {
                        if diceCount > 1 { diceCount -= 1 }
                    }) {
                        Image(systemName: "minus")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }

                    Button(action: {
                        isRolling = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isRolling = false
                        }
                    }) {
                        Text("Roll")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 100)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 10)

                    Button(action: {
                        if diceCount < 3 { diceCount += 1 }
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                }
                .padding(.bottom, 30)
            }
            .padding()
        }
    }
}

#Preview {
    Dices()
}
