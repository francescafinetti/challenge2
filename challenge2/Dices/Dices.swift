import SwiftUI
import AVFoundation
import Vision

struct Dices: View {
    @State private var isRolling = false
    @State private var diceCount = 1
    @State private var isCameraPresented = false
    @State private var prediction: String = "No predictions yet" // Per il risultato del modello
    @State private var isModalPresented = false // Stato per mostrare la lista
    @State private var savedPredictions: [String] = [] // Lista delle predizioni salvate

    var body: some View {
        NavigationView {
            ZStack {
                // Sfondo
                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.4), Color.accentColor.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // HStack per i pulsanti di navigazione
                    HStack {
                        Button(action: {
                            isModalPresented = true
                        }) {
                            Image(systemName: "list.bullet")
                                .font(.title2)
                                .foregroundColor(.accentColor)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                        }

                        Spacer()

                        Button(action: {
                            isCameraPresented = true
                        }) {
                            Image(systemName: "camera")
                                .font(.title2)
                                .foregroundColor(.accentColor)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer()

                    DiceView(isRolling: $isRolling, diceCount: $diceCount)
                        .frame(width: 400, height: 400)

                    HStack {
                        Button(action: {
                            if diceCount > 1 { diceCount -= 1 }
                        }) {
                            Image(systemName: "minus")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }

                        Button(action: {
                            isRolling = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isRolling = false
                            }
                        }) {
                            Text("Roll")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 100)
                                .background(Color.accentColor)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal, 10)

                        Button(action: {
                            if diceCount < 3 { diceCount += 1 }
                        }) {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Dices")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .sheet(isPresented: $isCameraPresented) {
            CameraLiveView(prediction: $prediction, savedPredictions: $savedPredictions)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $isModalPresented) {
            NavigationStack {
                List {
                    ForEach(savedPredictions, id: \.self) { prediction in
                        Text(prediction)
                    }
                    .onDelete(perform: deletePrediction) // Gestisce l'eliminazione
                }
                .navigationTitle("Saved Predictions")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Close") {
                            isModalPresented = false
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton() // Aggiunge il pulsante "Modifica" per abilitare lo swipe
                    }
                }
            }
        }
    }

    // Funzione per eliminare una predizione
    private func deletePrediction(at offsets: IndexSet) {
        savedPredictions.remove(atOffsets: offsets)
    }
}

#Preview {
    Dices()
}
