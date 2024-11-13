import SwiftUI

// Modello per rappresentare un Token
struct Token: Identifiable, Equatable {
    let id = UUID()
    let color: Color
}

struct RandomTokenView: View {
    @State private var tokens: [Token] = []
    @State private var numberOfTokensToAdd = 1
    @State private var selectedColor: Color = .red
    @State private var numberOfTokensToDraw = 1
    @State private var drawnTokens: [Token] = []
    
    let colors: [Color] = [.red, .green, .blue, .yellow, .purple, .orange, .pink, .teal, .black, .gray]
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.white, .blue.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Section(header: Text("Add Tokens").font(.title3).bold()) {
                            // Conteggio dei token per ogni colore
                            let colorCounts = countTokensByColor(tokens: tokens)
                            
                            // Picker per selezionare il colore
                            Picker("Select Color", selection: $selectedColor) {
                                ForEach(colors, id: \.self) { color in
                                    HStack {
                                        Circle()
                                            .fill(color)
                                            .frame(width: 20, height: 20)
                                        Text(colorName(for: color))
                                    }
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(height: 40)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            
                            HStack {
                                Stepper("Tokens to Add: \(numberOfTokensToAdd)", value: $numberOfTokensToAdd, in: 1...200)
                                    .padding()
                                
                                Button(action: {
                                    addTokens(count: numberOfTokensToAdd, color: selectedColor)
                                }) {
                                    Text("Add")
                                        .padding()
                                        .bold()
                                        .background(LinearGradient(
                                            gradient: Gradient(colors: [.blue, .blue]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                }
                            }
                        }
                        
                        // Mostra i Token Aggiunti
                        if !tokens.isEmpty {
                            
                            ScrollView(.horizontal) {
                                HStack(spacing: 20) {
                                    let colorCount = countTokensByColor(tokens: tokens)
                                    ForEach(colorCount.keys.sorted(), id: \.self) { colorName in
                                        let count = colorCount[colorName]!
                                        ZStack {
                                            Circle()
                                                .fill(colorForName(colorName))
                                                .frame(width: 50, height: 50)
                                                .shadow(radius: 5)
                                            
                                            // Badge con il numero di token
                                            Text("\(count)")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .padding(5)
                                                .background(Circle().fill(Color.black.opacity(0.7)))
                                                .offset(x: 15, y: -15)
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                        
                        Divider()
                        
                        // Sezione per estrarre Token
                        Section(header: Text("Draw Tokens").font(.title3).bold()) {
                            if !tokens.isEmpty {
                                HStack {
                                    Stepper("Tokens to Draw: \(numberOfTokensToDraw)", value: $numberOfTokensToDraw, in: 1...tokens.count)
                                        .padding()
                                    
                                    Button(action: {
                                        drawTokens(count: numberOfTokensToDraw)
                                    }) {
                                        Text("Draw")
                                            .padding()
                                            .bold()
                                            .background(LinearGradient(
                                                gradient: Gradient(colors: [.blue, .blue]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ))
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                    }
                                }
                            }
                            
                            // Mostra i Token estratti
                            if !drawnTokens.isEmpty {
                           
                                // Calcoliamo i contatori per ogni colore
                                let colorCount = countTokensByColor(tokens: drawnTokens)
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: 15) {
                                        // Per ogni colore, mostriamo solo un cerchio con il conteggio sopra
                                        ForEach(colorCount.keys.sorted(), id: \.self) { colorName in
                                            ZStack {
                                                // Mostra il cerchio con il colore
                                                Circle()
                                                    .fill(colorForName(colorName))
                                                    .frame(width: 50, height: 50)
                                                    .shadow(radius: 5)
                                                
                                                // Mostra il numero sopra il cerchio
                                                Text("\(colorCount[colorName]!)")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                    .padding(5)
                                                    .background(Circle().fill(Color.black.opacity(0.7)))
                                                    .offset(x: 15, y: -15) // Posizione sopra il cerchio
                                            }
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    .padding()
                    .navigationTitle("Random Tokens")
                }
            }
        }
    }
    
    private func addTokens(count: Int, color: Color) {
        withAnimation {
            for _ in 0..<count {
                tokens.append(Token(color: color))
            }
        }
    }
    
    private func removeToken(_ token: Token) {
        withAnimation {
            tokens.removeAll { $0.id == token.id }
        }
    }
    
    private func drawTokens(count: Int) {
        withAnimation {
            drawnTokens = Array(tokens.shuffled().prefix(count))
        }
    }
    
    private func countTokensByColor(tokens: [Token]) -> [String: Int] {
        var colorCount: [String: Int] = [:]
        for token in tokens {
            let colorName = colorName(for: token.color)
            colorCount[colorName, default: 0] += 1
        }
        return colorCount
    }
    
    private func colorName(for color: Color) -> String {
        switch color {
        case .red: return "Red"
        case .green: return "Green"
        case .blue: return "Blue"
        case .yellow: return "Yellow"
        case .purple: return "Purple"
        case .orange: return "Orange"
        case .pink: return "Pink"
        case .teal: return "Teal"
        case .black: return "Black"
        case .gray: return "Gray"
        default: return "Unknown"
        }
    }
    
    private func colorForName(_ name: String) -> Color {
        switch name {
        case "Red": return .red
        case "Green": return .green
        case "Blue": return .blue
        case "Yellow": return .yellow
        case "Purple": return .purple
        case "Orange": return .orange
        case "Pink": return .pink
        case "Teal": return .teal
        case "Black": return .black
        case "Gray": return .gray
        default: return .gray
        }
    }
}

struct RandomTokenView_Previews: PreviewProvider {
    static var previews: some View {
        RandomTokenView()
    }
}
