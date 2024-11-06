import SwiftUI

struct RuotaDellaFortunaView: View {
    @State private var playerNames: [String] = [] // Lista dei nomi dei giocatori
    @State private var newPlayerName: String = "" // Nome del nuovo giocatore
    @State private var selectedPlayer: String? = nil // Nome del giocatore selezionato
    @State private var rotationAngle: Double = 0 // Angolo di rotazione

    var body: some View {
        VStack {
            // Sezione per aggiungere giocatori
            HStack {
                TextField("Nome giocatore", text: $newPlayerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: addPlayer) {
                    Text("Aggiungi")
                }
                .disabled(playerNames.count >= 10 || newPlayerName.isEmpty) // Limita a 10 giocatori
            }
            .padding()
            
            // Mostra i giocatori inseriti
            List(playerNames, id: \.self) { name in
                Text(name)
            }
            
            // Ruota della fortuna
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                
                ForEach(0..<playerNames.count, id: \.self) { index in
                    // Calcola l'angolo per ogni spicchio
                    let startAngle = Angle(degrees: Double(index) * 360.0 / Double(playerNames.count))
                    let endAngle = Angle(degrees: Double(index + 1) * 360.0 / Double(playerNames.count))
                    
                    // Spicchio della ruota con il nome del giocatore
                    Path { path in
                        path.move(to: CGPoint(x: 150, y: 150)) // Centro del cerchio
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
                            .rotationEffect(Angle(degrees: 90 + (Double(index) * 360.0 / Double(playerNames.count))))
                            .position(x: 150, y: 50)
                    )
                }
            }
            .frame(width: 300, height: 300)
            .rotationEffect(Angle(degrees: rotationAngle))
            .onTapGesture(perform: spinWheel) // Fa girare la ruota quando viene toccata
            
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
