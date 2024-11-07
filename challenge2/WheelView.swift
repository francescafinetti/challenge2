import SwiftUI

struct RuotaDellaFortunaView: View {
    @State private var playerNames: [String] = []
    @State private var newPlayerName: String = ""
    @State private var selectedPlayer: String? = nil
    @State private var rotationAngle: Double = 0

    var body: some View {
        VStack {
            HStack {
                TextField("Nome giocatore", text: $newPlayerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: addPlayer) {
                    Text("Aggiungi")
                }
                .disabled(playerNames.count >= 10 || newPlayerName.isEmpty)
            }
            .padding()
            
            List(playerNames, id: \.self) { name in
                Text(name)
            }
            
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                
                ForEach(0..<playerNames.count, id: \.self) { index in
                    let startAngle = Angle(degrees: Double(index) * 360.0 / Double(playerNames.count))
                    let endAngle = Angle(degrees: Double(index + 1) * 360.0 / Double(playerNames.count))
                    
                    Path { path in
                        path.move(to: CGPoint(x: 150, y: 150))
                        path.addArc(
                            center: CGPoint(x: 150, y: 150),
                            radius: 150,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: false
                        )
                    }
                    .fill(Color(hue: Double(index) / Double(playerNames.count), saturation: 0.7, brightness: 0.9))
                    .overlay(
                        Text(playerNames[index])
                            .font(.caption)
                            .foregroundColor(.white)
                            .rotationEffect(startAngle + Angle(degrees: 180 / Double(playerNames.count)))
                            .position(
                                x: 150 + cos((startAngle.radians + endAngle.radians) / 2) * 100,
                                y: 150 + sin((startAngle.radians + endAngle.radians) / 2) * 100
                            )
                    )
                }
            }
            .frame(width: 300, height: 300)
            .rotationEffect(Angle(degrees: rotationAngle))
            
            Button(action: spinWheel) {
                Text("Spin")
                    .font(.title)
                    .bold()
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            // Mostra il giocatore selezionato
            if let selectedPlayer = selectedPlayer {
                Text("Giocatore selezionato: \(selectedPlayer)")
                    .font(.headline)
                    .padding()
            }
        }
    }
    
    // Funzione per aggiungere un giocatore
    private func addPlayer() {
        if !newPlayerName.isEmpty && playerNames.count < 10 {
            playerNames.append(newPlayerName)
            newPlayerName = ""
        }
    }
    
    // Funzione per far girare la ruota
    private func spinWheel() {
        let randomRotation = Double.random(in: 720...1440) // Rotazione casuale
        withAnimation(.easeOut(duration: 3)) {
            rotationAngle += randomRotation
        }
        
        // Determina il giocatore selezionato
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let selectedIndex = Int((rotationAngle.truncatingRemainder(dividingBy: 360)) / (360 / Double(playerNames.count)))
            selectedPlayer = playerNames[(playerNames.count - selectedIndex) % playerNames.count]
        }
    }
}

struct RuotaDellaFortunaView_Previews: PreviewProvider {
    static var previews: some View {
        RuotaDellaFortunaView()
    }
}
