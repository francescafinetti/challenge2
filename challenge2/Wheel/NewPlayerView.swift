import SwiftUI

import SwiftUI

struct Player2: Identifiable {
    let id = UUID()
    var name: String
    var color: Color
}

struct NewPlayerView: View {
    @Binding var showModal: Bool
    @Binding var players: [Player2]
    
    @State private var name: String = ""
    @State private var selectedColor: Color = .blue
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Player Name")) {
                    TextField("Enter player's name", text: $name)
                }
                
                Section(header: Text("Player Color")) {
                    ColorPicker("Select color", selection: $selectedColor)
                }
            }
            .navigationTitle("Add New Player")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showModal.toggle()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if !name.isEmpty {
                            let newPlayer = Player2(name: name, color: selectedColor)
                            players.append(newPlayer)
                            showModal.toggle()
                        }
                    }
                }
            }
        }
    }
}

struct NewPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        NewPlayerView(showModal: .constant(true), players: .constant([]))
    }
}
