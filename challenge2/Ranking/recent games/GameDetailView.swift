import SwiftUI

struct GameDetailView: View {
    let game: GameSession
    @EnvironmentObject var gameManager: GameManager
    @State private var showingResumeView = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Sfondo gradiente per mantenere lo stesso stile
                LinearGradient(
                    gradient: Gradient(colors: [.white, .accentColor.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    // Dettagli del gioco
                    ZStack {
                        // Sfondo
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.8))
                            .shadow(radius: 5)
                        
                        // Contenuto
                        VStack(alignment: .leading, spacing: 10) {
                            Text(game.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Description: \(game.description)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text("Played on \(formattedDate(game.date))")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                    .frame(width: 320, height: 130)
                    .padding(.horizontal)

                    
                    
                    // Lista dei giocatori con lo stesso stile di RecentGamesView
                    List {
                        ForEach(game.players) { player in
                            HStack(alignment: .top, spacing: 12) {
                                if let image = player.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                        .padding(.trailing, 8)
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .foregroundColor(.gray)
                                        )
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(player.testo)
                                        .font(.headline)
                                    
                                    Text("\(player.playerpoints) points")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                            }
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .shadow(radius: 3)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                    .padding()
                    
                    // Pulsante per riprendere la partita
                    Button(action: {
                        showingResumeView = true
                    }) {
                        Text("Resume Game")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    .sheet(isPresented: $showingResumeView) {
                        ResumeRankingView(game: game)
                    }
                }
            }
            .navigationTitle("Game Details")
        }
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
        Player(image: nil, testo: "Player 1", playerpoints: 10, playerBadge: "⭐️"),
        Player(image: nil, testo: "Player 2", playerpoints: 20, playerBadge: "🏅")
    ]
    let sampleGame = GameSession(name: "Sample Game", date: Date(), players: samplePlayers, image: nil, description: "Sample description")
    
    return GameDetailView(game: sampleGame)
        .environmentObject(GameManager())
}
