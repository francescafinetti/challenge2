import SwiftUI
import AVFoundation
import Vision

struct CameraLiveView: UIViewControllerRepresentable {
    @Binding var prediction: String
    @Binding var savedPredictions: [String]

    func makeUIViewController(context: Context) -> CameraLiveViewController {
        let controller = CameraLiveViewController()
        controller.predictionBinding = $prediction
        controller.savedPredictionsBinding = $savedPredictions
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraLiveViewController, context: Context) {}
}

class CameraLiveViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var visionModel: VNCoreMLModel!
    private var predictionLabel: UILabel!
    private var saveButton: UIButton!
    var predictionBinding: Binding<String>?
    var savedPredictionsBinding: Binding<[String]>?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCamera()
        setupVision()
        setupPredictionLabel()
        setupSaveButton()
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo

        guard let videoDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("Unable to access camera")
        }

        guard let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            fatalError("Unable to create video input")
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        previewLayer.frame = view.bounds

        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }

    private func setupVision() {
        guard let model = try? VNCoreMLModel(for: ImageClassifierProva(configuration: MLModelConfiguration()).model) else {
            fatalError("Unable to load ML model")
        }
        visionModel = model
    }

    private func setupPredictionLabel() {
        predictionLabel = UILabel()
        predictionLabel.text = "Nessuna predizione disponibile"
        predictionLabel.textAlignment = .center
        predictionLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        predictionLabel.textColor = .white
        predictionLabel.font = UIFont.boldSystemFont(ofSize: 16)
        predictionLabel.layer.cornerRadius = 10
        predictionLabel.clipsToBounds = true

        view.addSubview(predictionLabel)

        predictionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            predictionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            predictionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            predictionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            predictionLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupSaveButton() {
        saveButton = UIButton(type: .system)
        saveButton.setTitle("Salva Predizione", for: .normal)
        saveButton.backgroundColor = UIColor.systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(savePrediction), for: .touchUpInside)

        view.addSubview(saveButton)

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func savePrediction() {
        guard let prediction = predictionBinding?.wrappedValue else { return }
        savedPredictionsBinding?.wrappedValue.append(prediction)
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                DispatchQueue.main.async {
                    self?.updatePredictionLabel(text: "Nessuna predizione disponibile")
                }
                return
            }

            DispatchQueue.main.async {
                let predictionText = "\(topResult.identifier) (\(Int(topResult.confidence * 100))%)"
                self?.updatePredictionLabel(text: predictionText)
            }
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }

    private func updatePredictionLabel(text: String) {
        predictionLabel.text = text
        predictionBinding?.wrappedValue = text
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        previewLayer.frame = view.bounds
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.stopRunning()
        }
    }
}
