//
//  Untitled.swift
//  challenge2
//
//  Created by Francesca Finetti on 12/11/24.
//

import SwiftUI

struct ResumeRankingView: View {
    @State private var players: [Player]
    @EnvironmentObject var gameManager: GameManager
    @Environment(\.dismiss) var dismiss
    let game: GameSession

    init(game: GameSession) {
        self.game = game
        self._players = State(initialValue: game.players)
    }

    var body: some View {
        NavigationStack {
            VStack {
                if players.isEmpty {
                    Text("No players available")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(players.indices, id: \.self) { index in
                            playerEntry(player: $players[index])
                                .padding(.vertical, 4)
                        }
                        .onDelete(perform: deletePlayer)
                    }
                    .listStyle(PlainListStyle())
                    .cornerRadius(15)
                    .padding()
                }
                
                Spacer()
                
                Button(action: {
                    saveGame()
                    dismiss()
                }) {
                    Text("Save & Exit")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Resume Game: \(game.name)")
        }
    }
    
    private func playerEntry(player: Binding<Player>) -> some View {
        HStack {
            // Mostra l'immagine del giocatore se disponibile
            if let image = player.wrappedValue.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(.trailing, 8)
            }
            
            VStack(alignment: .leading) {
                Text(player.wrappedValue.testo)
                    .font(.headline)
                
                HStack {
                    Text("Points:")
                    
                    // Modifica qui per utilizzare correttamente $player
                    TextField("Points", value: player.playerpoints, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 60)
                }
            }
        }
    }

    
    private func deletePlayer(at offsets: IndexSet) {
        players.remove(atOffsets: offsets)
    }
    
    private func saveGame() {
        gameManager.updateGame(game: game, with: players)
        print("Partita aggiornata: \(game.name)")
    }
}
