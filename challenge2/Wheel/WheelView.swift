import SwiftUI

struct Wheel: View {
    @State private var players: [Player2] = []
    @State private var selectedPlayer: String? = nil
    @State private var rotationAngle: Double = 0
    @State private var showAlert = false
    @State private var showAddPlayerModal = false
    @State private var showPlayerListModal = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.white, .accentColor.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                    )
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Ruota dei giocatori
                    ZStack {
                        Circle()
                            .fill(Color.accentColor.opacity(0.2))
                            .frame(width: 300, height: 300)
                            .overlay(Circle().stroke(Color.white, lineWidth: 5))
                        
                        ForEach(0..<players.count, id: \.self) { index in
                            let startAngle = Angle(degrees: Double(index) * 360.0 / Double(players.count))
                            let endAngle = Angle(degrees: Double(index + 1) * 360.0 / Double(players.count))
                            
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
                            .fill(players[index].color)
                            .overlay(
                                Text(players[index].name)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .rotationEffect(startAngle + Angle(degrees: 180 / Double(players.count)))
                                    .position(
                                        x: 150 + cos((startAngle.radians + endAngle.radians) / 2) * 100,
                                        y: 150 + sin((startAngle.radians + endAngle.radians) / 2) * 100
                                    )
                            )
                        }
                    }
                    .frame(width: 300, height: 300)
                    .rotationEffect(Angle(degrees: rotationAngle))
                    
                    // Freccia che indica il giocatore selezionato
                    Image(systemName: "triangle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.red)
                        .offset(y: -20)
                    
                    // Pulsante per girare la ruota
                    Button(action: spinWheel) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 120, height: 50)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            
                            Text("Spin")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Wheel")
            .toolbar {
                // Pulsante per aprire la lista dei giocatori
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showPlayerListModal = true
                    }) {
                        Image(systemName: "list.bullet")
                    }
                }
                
                // Pulsante "Reset"
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: resetGame) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                
                // Pulsante per aggiungere nuovi giocatori
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddPlayerModal = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddPlayerModal) {
                NewPlayerView(showModal: $showAddPlayerModal, players: $players)
            }
            .sheet(isPresented: $showPlayerListModal) {
                PlayerListView(showModal: $showPlayerListModal, players: $players)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Selected Player"),
                    message: Text(selectedPlayer ?? "No Player Selected"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // Funzione per resettare il gioco
    private func resetGame() {
        players.removeAll()
        selectedPlayer = nil
        rotationAngle = 0
    }
    
    // Funzione per girare la ruota
    private func spinWheel() {
        let randomRotation = Double.random(in: 720...1440)
        withAnimation(.easeOut(duration: 3)) {
            rotationAngle += randomRotation
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if players.isEmpty { return }
            
            // Calcolo del giocatore selezionato
            let sliceAngle = 360.0 / Double(players.count)
            let normalizedAngle = (rotationAngle.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
            let selectedIndex = Int((360.0 - normalizedAngle + 90).truncatingRemainder(dividingBy: 360) / sliceAngle)
            
            selectedPlayer = players[selectedIndex % players.count].name
            showAlert = true
        }
    }
}

struct Wheel_Previews: PreviewProvider {
    static var previews: some View {
        Wheel()
    }
}
