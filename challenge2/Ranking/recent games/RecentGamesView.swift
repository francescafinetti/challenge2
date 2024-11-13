import SwiftUI

struct RecentGamesView: View {
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
                    if gameManager.recentGames.isEmpty {
                        Spacer()
                        Text("No games played yet!")
                            .font(.title)
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        List {
                            ForEach(gameManager.recentGames) { game in
                                NavigationLink(destination: GameDetailView(game: game)) {
                                    HStack(alignment: .top, spacing: 12) {
                                        if let image = game.image {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 60, height: 60)
                                                .clipShape(Circle())
                                                .shadow(radius: 5)
                                        } else {
                                            Circle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 60, height: 60)
                                                .overlay(
                                                    Image(systemName: "photo")
                                                        .foregroundColor(.gray)
                                                )
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(game.name)
                                                .font(.headline)
                                            
                                            Text(game.description)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                            
                                            Text("Played on \(formattedDate(game.date))")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack {
                                            Text("\(game.players.count)")
                                                .font(.title3)
                                                .fontWeight(.bold)
                                                .foregroundColor(.blue)
                                            
                                            Text("players")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(15)
                                    .shadow(radius: 5)
                                }
                            }
                            .onDelete(perform: deleteGame) // Aggiunto .onDelete
                            .listRowBackground(Color.clear)
                        }
                        .listStyle(PlainListStyle())
                        .padding()
                    }
                }
            }
            .navigationTitle("Games History")
        }
    }
    
    /// Metodo per eliminare una partita
    private func deleteGame(at offsets: IndexSet) {
        gameManager.recentGames.remove(atOffsets: offsets)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    let samplePlayers = [
        Player(image: nil, testo: "Player 1", playerpoints: 50, playerBadge: "⭐️"),
        Player(image: nil, testo: "Player 2", playerpoints: 30, playerBadge: "🏅"),
        Player(image: nil, testo: "Player 3", playerpoints: 20, playerBadge: "🎖️")
    ]
    
    let sampleGame = GameSession(
        name: "Sample Game",
        date: Date(),
        players: samplePlayers,
        image: nil,
        description: "An exciting game played with friends."
    )
    
    let gameManager = GameManager()
    gameManager.recentGames = [sampleGame]
    
    return RecentGamesView()
        .environmentObject(gameManager)
}
