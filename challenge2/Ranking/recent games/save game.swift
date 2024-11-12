import SwiftUI

struct SaveGameView: View {
    @Binding var players: [Player]
    @EnvironmentObject var gameManager: GameManager
    @Environment(\.dismiss) var dismiss
    @State private var gameName: String = ""
    @State private var gameDescription: String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter game name", text: $gameName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Enter game description", text: $gameDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                }
                
                Button("Select Photo") {
                    showImagePicker = true
                }
                .padding()
                
                Button(action: {
                    saveGame()
                    dismiss()
                }) {
                    Text("Save Game")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
            }
            .sheet(isPresented: $showImagePicker) {
                CustomImagePicker(selectedImage: $selectedImage)
            }
        }
    }
    
    private func saveGame() {
        guard !gameName.isEmpty else { return }
        gameManager.saveGame(players: players, gameName: gameName, image: selectedImage, description: gameDescription)
        print("Gioco salvato in SaveGameView")
    }
}
