import SwiftUI

struct Wheel: View {
    @State private var playerNames: [String] = []
    @State private var newPlayerName: String = ""
    @State private var selectedPlayer: String? = nil
    @State private var rotationAngle: Double = 0
    @State private var showAlert = false
    private let sliceColors: [Color] = [
        .blue, .red, .green, .yellow, .cyan, .purple, .orange, .pink, .teal, .indigo
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.4), Color.white.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    HStack {
                        TextField("Player Name", text: $newPlayerName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        Button(action: addPlayer) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                                    .frame(width: 80, height: 32)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                
                                Text("Add")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                            }
                        }
                        .disabled(playerNames.count >= 10 || newPlayerName.isEmpty)
                    }
                    .padding(.top, 35)
                    ScrollView {
                        VStack(spacing: 5) {
                            ForEach(playerNames, id: \.self) { name in
                                HStack {
                                    Text(name)
                                        .font(.body)
                                        .foregroundColor(.black)
                                        .padding(.leading)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        deletePlayer(name)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .padding()
                                    }
                                }
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .padding(.vertical, 5)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(10)
                                .shadow(radius: 2)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 150)
                    
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 300, height: 300)
                            .overlay(Circle().stroke(Color.white, lineWidth: 5))
                        
                        ForEach(0..<playerNames.count, id: \.self) { index in
                            let startAngle = Angle(degrees: Double(index) * 360.0 / Double(playerNames.count))
                            let endAngle = Angle(degrees: Double(index + 1) * 360.0 / Double(playerNames.count))
                            
                            Path { path in
                                path.move(to: CGPoint(x: 150, y: 150))
                                path.addArc(
                                    center: CGPoint(x: 150, y: 150),
                                    radius: 150,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: false
                                )
                            }
                            .fill(sliceColors[index % sliceColors.count])
                            .overlay(
                                Text(playerNames[index])
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .rotationEffect(startAngle + Angle(degrees: 180 / Double(playerNames.count)))
                                    .position(
                                        x: 150 + cos((startAngle.radians + endAngle.radians) / 2) * 100,
                                        y: 150 + sin((startAngle.radians + endAngle.radians) / 2) * 100
                                    )
                            )
                            .overlay(
                                Path { path in
                                    path.move(to: CGPoint(x: 150, y: 150))
                                    path.addArc(
                                        center: CGPoint(x: 150, y: 150),
                                        radius: 150,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: false
                                    )
                                }
                                    .stroke(Color.white, lineWidth: 1)
                            )
                        }
                    }
                    .frame(width: 300, height: 300)
                    .rotationEffect(Angle(degrees: rotationAngle))
                    
                    Image(systemName: "triangle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.red)
                        .offset(y: -20)
                    
                    HStack {
                        Button(action: spinWheel) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(width: 120, height: 50)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                
                                Text("Spin")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 80)
                        
                        Button(action: resetGame) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(width: 120, height: 50)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                
                                Text("Reset")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 80)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Selected Player"),
                    message: Text(selectedPlayer ?? "No Player Selected"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationTitle("Spin the Wheel")
    }
    
    
    
    
    
    
    private func addPlayer() {
        if !newPlayerName.isEmpty && playerNames.count < 10 {
            playerNames.append(newPlayerName)
            newPlayerName = ""
        }
    }
    private func deletePlayer(_ name: String) {
        playerNames.removeAll { $0 == name }
    }
    private func resetGame() {
        playerNames.removeAll()
        selectedPlayer = nil
        rotationAngle = 0
    }
    private func spinWheel() {
        let randomRotation = Double.random(in: 720...1440)
        withAnimation(.easeOut(duration: 3)) {
            rotationAngle += randomRotation
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let selectedIndex = Int((rotationAngle.truncatingRemainder(dividingBy: 360)) / (360 / Double(playerNames.count)))
            selectedPlayer = playerNames[(playerNames.count - selectedIndex) % playerNames.count]
            showAlert = true
        }
    }
}



struct Wheel_Previews: PreviewProvider {
    static var previews: some View {
        Wheel()
    }
}

