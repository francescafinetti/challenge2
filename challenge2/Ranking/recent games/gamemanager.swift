import SwiftUI

struct GameSession: Identifiable {
    let id = UUID()
    var name: String
    var date: Date
    var players: [Player]
    var image: UIImage?
    var description: String
}

class GameManager: ObservableObject {
    @Published var recentGames: [GameSession] = []
    
    func saveGame(players: [Player], gameName: String, image: UIImage?, description: String) {
        guard !players.isEmpty else { return }
        let newSession = GameSession(
            name: gameName,
            date: Date(),
            players: players,
            image: image,
            description: description
        )
        recentGames.append(newSession)
        
        // Debug
        print("Gioco salvato con nome: \(gameName)")
        print("Numero di giochi salvati: \(recentGames.count)")
    }
    
    func updateGame(game: GameSession, with players: [Player]) {
        if let index = recentGames.firstIndex(where: { $0.id == game.id }) {
            recentGames[index].players = players
            recentGames[index].date = Date() // Aggiorna la data
        }
    }
}

