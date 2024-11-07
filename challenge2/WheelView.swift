import SwiftUI

struct RuotaDellaFortunaView: View {
    @State private var playerNames: [String] = []
    @State private var newPlayerName: String = ""
    @State private var selectedPlayer: String? = nil
    @State private var rotationAngle: Double = 0

    var body: some View {
        VStack {
            // Input per aggiungere un giocatore
            HStack {
                TextField("Nome giocatore", text: $newPlayerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: addPlayer) {
                    Text("Aggiungi")
                }
                .disabled(playerNames.count >= 10 || newPlayerName.isEmpty)
            }
            .padding()
            
            // Lista dei giocatori con possibilità di eliminare tramite swipe
            List {
                ForEach(playerNames, id: \.self) { name in
                    Text(name)
                }
                .onDelete(perform: deletePlayer)
            }
            
            // Disegno della ruota della fortuna
            ZStack {
                Circle()
                    .fill(Color.red)
                    .saturation(0.7)
                
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
                    .fill(Color(hue: Double(index) / Double(playerNames.count), saturation: 0.7, brightness: 0.9)) // Colori pastello
                    .overlay(
                        Text(playerNames[index])
                            .font(.caption)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(5)
                            .foregroundColor(.black)
                            .rotationEffect(startAngle + Angle(degrees: 180 / Double(playerNames.count)))
                            .position(
                                x: 150 + cos((startAngle.radians + endAngle.radians) / 2) * 100,
                                y: 150 + sin((startAngle.radians + endAngle.radians) / 2) * 100
                            )
                    )
                }
                Image(systemName: "star.circle")
                    .font(.system(size:30))
                    .foregroundColor(.yellow)
            }
            .frame(width: 300, height: 300)
            .rotationEffect(Angle(degrees: rotationAngle))
            
            Image(systemName: "triangle")
            
            // Bottone per far girare la ruota
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

            // Bottone per resettare la lista dei giocatori e la ruota
            Button(action: resetGame) {
                Text("Reset")
                    .font(.title2)
                    .padding()
                    .background(Color.red)
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
    
    // Funzione per eliminare un giocatore
    private func deletePlayer(at offsets: IndexSet) {
        playerNames.remove(atOffsets: offsets)
    }
    
    // Funzione per resettare la ruota e i giocatori
    private func resetGame() {
        playerNames.removeAll()
        selectedPlayer = nil
        rotationAngle = 0
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
