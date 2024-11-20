import SwiftUI
import UIKit

struct Player: Identifiable {
    let id = UUID()
    var image: UIImage?
    var testo: String
    var playerpoints: Int
    var playerBadge: String
    var additionalPoints: Int? = nil // Punti da aggiungere
}

struct playerEntry: View {
    @Binding var player: Player
    @Binding var players: [Player]
    
    @State private var showAlert = false
    @State private var newPoints = ""

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .accentColor.opacity(0.05)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 350, height: 130)
            
            HStack {
                if let image = player.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(player.testo)
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(player.playerpoints) pts")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    newPoints = "\(player.playerpoints)"
                    showAlert = true
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 24))
                }
                .alert("Actual Score", isPresented: $showAlert) {
                    TextField("New Score", text: $newPoints)
                        .keyboardType(.numberPad)
                    
                    Button("Save", action: savePoints)
                    Button("Back", role: .cancel) { }
                }
                
                let position = players.firstIndex(where: { $0.id == player.id })! + 1
                if position == 1 {
                    Image(systemName: "rosette")
                        .foregroundColor(.yellow)
                        .font(.system(size: 24))
                } else if position == 2 {
                    Image(systemName: "rosette")
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
                } else if position == 3 {
                    Image(systemName: "rosette")
                        .foregroundColor(.brown)
                        .font(.system(size: 24))
                }
            }
            .padding(.horizontal, 8)
        }
    }
    
    private func savePoints() {
        if let updatedPoints = Int(newPoints) {
            player.playerpoints = updatedPoints
            players.sort { $0.playerpoints > $1.playerpoints }
        }
    }
}

struct AddPlayerView: View {
    @Binding var players: [Player]
    @Environment(\.dismiss) var dismiss
    @State private var playerName = ""
    @State private var playerPoints = 0
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Player Details")) {
                    TextField("Enter Player Name", text: $playerName)
                    
                    TextField("Starting Points", value: $playerPoints, format: .number)
                        .keyboardType(.numberPad)
                    
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        HStack {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            } else {
                                Image(systemName: "person.crop.circle.fill.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.accentColor)
                            }
                            Text("Select Image")
                        }
                    }
                }
            }
            .navigationTitle("Add New Player")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addPlayer()
                        dismiss()
                    }
                    .disabled(playerName.isEmpty)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
    
    private func addPlayer() {
        let newPlayer = Player(image: selectedImage, testo: playerName, playerpoints: playerPoints, playerBadge: "badge")
        players.append(newPlayer)
        players.sort { $0.playerpoints > $1.playerpoints }
    }
}
