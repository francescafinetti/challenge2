import SwiftUI

struct RecentGamesView: View {
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.2)]),
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
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    RecentGamesView()
        .environmentObject(GameManager())
}
