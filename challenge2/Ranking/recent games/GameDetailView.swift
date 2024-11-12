//
//  Untitled.swift
//  challenge2
//
//  Created by Francesca Finetti on 12/11/24.
//

import SwiftUI

struct GameDetailView: View {
    let game: GameSession
    @EnvironmentObject var gameManager: GameManager
    @State private var showingResumeView = false

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(game.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Description: \(game.description)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Played on \(formattedDate(game.date))")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
            
            List {
                ForEach(game.players) { player in
                    HStack {
                        if let image = player.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .padding(.trailing, 8)
                        }
                        VStack(alignment: .leading) {
                            Text(player.testo)
                                .font(.headline)
                            Text("\(player.playerpoints) points")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            
            Button(action: {
                showingResumeView = true
            }) {
                Text("Resume Game")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $showingResumeView) {
                ResumeRankingView(game: game)
            }
        }
        .navigationTitle("Game Details")
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
