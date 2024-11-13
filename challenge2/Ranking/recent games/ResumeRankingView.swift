import SwiftUI

struct ResumeRankingView: View {
    @State private var players: [Player]
    @EnvironmentObject var gameManager: GameManager
    @Environment(\.dismiss) var dismiss
    let game: GameSession
    @State private var selectedPlayerIndex: Int?
    @State private var showingImagePicker = false

    init(game: GameSession) {
        self.game = game
        self._players = State(initialValue: game.players)
    }

    var body: some View {
        NavigationStack {
            Form {
                ForEach(players.indices, id: \.self) { index in
                    Section(header: Text("Player \(index + 1)")) {
                        HStack {
                            // Campo per il nome del giocatore
                            TextField("Player Name", text: $players[index].testo)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            // Pulsante per eliminare il giocatore
                            Button(action: {
                                deletePlayer(at: index)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Campo per i punti del giocatore
                        TextField("Points", value: $players[index].playerpoints, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        // Pulsante per selezionare un'immagine
                        Button(action: {
                            selectedPlayerIndex = index
                            showingImagePicker = true
                        }) {
                            HStack {
                                if let image = players[index].image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                } else {
                                    Image(systemName: "person.crop.circle.fill.badge.plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.blue)
                                }
                                Text("Select Image")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Players")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveGame()
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                if let selectedIndex = selectedPlayerIndex {
                    ImagePicker(selectedImage: $players[selectedIndex].image)
                }
            }
        }
    }
    
    /// Funzione per eliminare un giocatore
    private func deletePlayer(at index: Int) {
        players.remove(at: index)
    }
    
    private func saveGame() {
        gameManager.updateGame(game: game, with: players)
        print("Partita aggiornata: \(game.name)")
    }
}
