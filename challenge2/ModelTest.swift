//import SwiftUI
//import CoreML
//import Vision
//
//struct ContentView: View {
//    @State private var prediction: String = "Nessuna previsione"
//    @State private var showImagePicker = false
//    @State private var selectedImage: UIImage?
//
//    var body: some View {
//        VStack {
//            if let image = selectedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 200, height: 200)
//                    .cornerRadius(15)
//            } else {
//                Rectangle()
//                    .fill(Color.gray.opacity(0.3))
//                    .frame(width: 200, height: 200)
//                    .cornerRadius(15)
//                    .overlay(Text("Seleziona un'immagine"))
//            }
//
//            Text(prediction)
//                .padding()
//
//            HStack {
//                Button("Seleziona immagine") {
//                    showImagePicker = true
//                }
//
//                Button("Classifica immagine") {
//                    if let image = selectedImage {
//                        classifyImage(image: image)
//                    } else {
//                        prediction = "Nessuna immagine selezionata"
//                    }
//                }
//            }
//        }
//        .sheet(isPresented: $showImagePicker) {
//            ImagePickerModel(image: $selectedImage)
//        }
//    }
//
//    func classifyImage(image: UIImage) {
//        // Inizializza il modello
//        guard let model = try? DiceRecognizer_1(configuration: .init()) else {
//            prediction = "Errore nel caricamento del modello"
//            return
//        }
//
//        // Converti l'immagine in CVPixelBuffer
//        guard let buffer = image.toCVPixelBuffer() else {
//            prediction = "Errore nella conversione dell'immagine"
//            return
//        }
//
//        // Fai la previsione
//        if let result = try? model.prediction(image: buffer) {
//            // Stampa l'intero risultato per analizzarlo
//            print("Output del modello: \(result)")
//            
//            // Prova ad accedere a classLabel o altre proprietà disponibili
//            if let probabilities = result.featureValue(for: "classLabelProbs")?.dictionaryValue as? [String: Double],
//               let bestMatch = probabilities.max(by: { $0.value < $1.value }) {
//                prediction = "Risultato: \(bestMatch.key) con confidenza \(Int(bestMatch.value * 100))%"
//            } else {
//                prediction = "Impossibile interpretare il risultato"
//            }
//        } else {
//            prediction = "Errore nella previsione"
//        }
//    }
//}
//
//// Estensione per convertire UIImage in CVPixelBuffer
//extension UIImage {
//    func toCVPixelBuffer() -> CVPixelBuffer? {
//        let attributes: [String: Any] = [
//            kCVPixelBufferCGImageCompatibilityKey as String: true,
//            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
//        ]
//
//        var pixelBuffer: CVPixelBuffer?
//        let status = CVPixelBufferCreate(
//            kCFAllocatorDefault,
//            Int(self.size.width),
//            Int(self.size.height),
//            kCVPixelFormatType_32ARGB,
//            attributes as CFDictionary,
//            &pixelBuffer
//        )
//
//        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
//            return nil
//        }
//
//        CVPixelBufferLockBaseAddress(buffer, [])
//        let context = CGContext(
//            data: CVPixelBufferGetBaseAddress(buffer),
//            width: Int(self.size.width),
//            height: Int(self.size.height),
//            bitsPerComponent: 8,
//            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
//            space: CGColorSpaceCreateDeviceRGB(),
//            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
//        )
//
//        context?.draw(self.cgImage!, in: CGRect(origin: .zero, size: self.size))
//        CVPixelBufferUnlockBaseAddress(buffer, [])
//
//        return buffer
//    }
//}
