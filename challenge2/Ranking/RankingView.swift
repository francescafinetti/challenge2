import SwiftUI
import UIKit


struct RankingView_: View {
    @State private var players: [Player] = []
    @State private var showingAddPlayerModal = false
    
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
        }
    }
    
    private func deletePlayer(at offsets: IndexSet) {
        players.remove(atOffsets: offsets)
        sortPlayers()
    }
    
    private func sortPlayers() {
        players.sort { $0.playerpoints > $1.playerpoints }
    }
    
    
}


#Preview {
    RankingView_()
}
