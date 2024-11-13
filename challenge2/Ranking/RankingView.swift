import SwiftUI

struct RankingView_: View {
    @State private var players: [Player] = []
    @State private var showingAddPlayerModal = false
    @State private var showingSaveGameModal = false
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.white, .blue.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    if players.isEmpty {
                        Spacer()
                        Text("Nothing yet here!")
                            .font(.title)
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        List {
                            ForEach(players.indices, id: \.self) { index in
                                playerEntry(player: $players[index], players: $players)
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    .padding(.vertical, 4)
                            }
                            .onDelete(perform: deletePlayer)
                        }
                        .listStyle(PlainListStyle())
                        .cornerRadius(15)
                        .padding()
                    }
                }
            }
            .navigationTitle("Rankings")
            .toolbar {
                // Pulsante "Reset"
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        resetPlayers()
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
                
                // Pulsante "Salva"
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSaveGameModal = true
                    }) {
                        Image(systemName: "checkmark")
                    }
                }
                
                // Pulsante "Aggiungi"
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddPlayerModal = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPlayerModal) {
                AddPlayerView(players: $players)
            }
            .sheet(isPresented: $showingSaveGameModal) {
                SaveGameView(players: $players)
            }
        }
    }
    
    private func deletePlayer(at offsets: IndexSet) {
        players.remove(atOffsets: offsets)
        sortPlayers()
    }
    
    private func sortPlayers() {
        players.sort { $0.playerpoints > $1.playerpoints }
    }
    
    private func resetPlayers() {
        players.removeAll()
    }
}

#Preview {
    RankingView_()
        .environmentObject(GameManager())
}
