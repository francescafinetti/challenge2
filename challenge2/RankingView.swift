import SwiftUI
import UIKit

struct Player: Identifiable {
    let id = UUID()
    var image: UIImage?
    var testo: String
    var playerpoints: Int
    var rank: Int
    var playerBadge: String
}

struct RankingView_: View {
    @State private var players: [Player] = []
    @State private var showingCustomAlert = false
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            
            VStack {
                Text("Player Rankings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                if players.isEmpty {
                    Spacer()
                    
                    VStack {
                        Text("No players yet!")
                            .font(.title)
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)
                        
                        Button(action: {
                            showingCustomAlert = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24))
                                Text("Add Player")
                                    .font(.headline)
                            }
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                    }
                    
                    Spacer()
                    
                } else {
                    List {
                        ForEach(players.indices, id: \.self) { index in
                            playerEntry(player: $players[index], position: index + 1) {
                                sortPlayers()
                            }
                            .listRowBackground(Color.clear)
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deletePlayer)
                    }
                    .listStyle(PlainListStyle())
                    .cornerRadius(15)
                    .padding()
                    
                    Button(action: {
                        showingCustomAlert = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                            Text("Add Player")
                                .font(.headline)
                        }
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    .padding(.bottom, 20)
                }
            }
            
            if showingCustomAlert {
                CustomAlertView(players: $players, showingAlert: $showingCustomAlert, sortPlayers: sortPlayers)
            }
        }
    }
    
    private func sortPlayers() {
        players.sort { $0.playerpoints > $1.playerpoints }
    }
    
    private func deletePlayer(at offsets: IndexSet) {
        players.remove(atOffsets: offsets)
        sortPlayers()
    }
}

struct CustomAlertView: View {
    @Binding var players: [Player]
    @Binding var showingAlert: Bool
    var sortPlayers: () -> Void
    @State private var playerName = ""
    @State private var playerPoints = 0
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Add New Player")
                    .font(.headline)
                
                TextField("Player Name", text: $playerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Starting Points", value: $playerPoints, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .keyboardType(.numberPad)
                
                Button(action: {
                    showingImagePicker = true
                }) {
                    HStack {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        } else {
                            Image(systemName: "person.crop.circle.fill.badge.plus")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                        }
                        Text("Select Image")
                    }
                }
                
                HStack {
                    Button("Cancel") {
                        showingAlert = false
                    }
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("Add Player") {
                        let newPlayer = Player(image: selectedImage, testo: playerName, playerpoints: playerPoints, rank: players.count + 1, playerBadge: "badge")
                        players.append(newPlayer)
                        showingAlert = false
                        sortPlayers()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 20)
            .frame(maxWidth: 300)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
}

struct playerEntry: View {
    @Binding var player: Player
    var position: Int
    var onScoreChange: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                .frame(width: 350, height: 130)
            
            HStack {
                ZStack(alignment: .topLeading) {
                    // Immagine del giocatore
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
                    
                    if position == 1 {
                        Image(systemName: "rosette")
                            .font(.system(size: 24))
                            .foregroundColor(.yellow)
                            .offset(x: -5, y: -5)
                    } else if position == 2 {
                        Image(systemName: "rosette")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                            .offset(x: -5, y: -5)
                    } else if position == 3 {
                        Image(systemName: "rosette")
                            .font(.system(size: 24))
                            .foregroundColor(.brown)
                            .offset(x: -5, y: -5)
                    }
                }
                .padding(.leading, position <= 3 ? 0 : 10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(player.testo)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(player.playerpoints) pts")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading, 10)
                
                Spacer()
                
                TextField("Score", value: $player.playerpoints, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80, height: 40)
                    .padding(.trailing, 16)
                    .onChange(of: player.playerpoints) {
                        onScoreChange()
                    }
            }
            .padding(.horizontal, 8)
        }
    }
}





#Preview {
    RankingView_()
}
