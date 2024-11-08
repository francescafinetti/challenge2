import SwiftUI

struct PlayerListView: View {
    @Binding var showModal: Bool
    @Binding var players: [Player2]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(players) { player in
                    HStack {
                        Text(player.name)
                            .font(.body)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Circle()
                            .fill(player.color)
                            .frame(width: 20, height: 20)
                    }
                }
                .onDelete(perform: deletePlayer)
            }
            .navigationTitle("Players")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        showModal.toggle()
                    }
                }
            }
        }
    }
    
    private func deletePlayer(at offsets: IndexSet) {
        players.remove(atOffsets: offsets)
    }
}
