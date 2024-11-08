import UIKit
import SwiftUI

class WheelViewController: UIViewController {
    
    // UI Elements
    let wheelImageView = UIImageView()
    let spinButton = UIButton(type: .system)
    let nameTextField = UITextField()
    let addButton = UIButton(type: .system)
    var names: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupWheel()
        setupControls()
    }
    
    // Set up the wheel image view
    func setupWheel() {
        wheelImageView.contentMode = .scaleAspectFit
        wheelImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wheelImageView)
        
        NSLayoutConstraint.activate([
            wheelImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wheelImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            wheelImageView.widthAnchor.constraint(equalToConstant: 300),
            wheelImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        drawWheel()
    }
    
    // Set up controls for adding names and spinning the wheel
    func setupControls() {
        nameTextField.placeholder = "Enter name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(addName), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        
        spinButton.setTitle("Spin the Wheel", for: .normal)
        spinButton.addTarget(self, action: #selector(spinWheel), for: .touchUpInside)
        spinButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinButton)
        
        NSLayoutConstraint.activate([
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            nameTextField.topAnchor.constraint(equalTo: wheelImageView.bottomAnchor, constant: 20),
            nameTextField.widthAnchor.constraint(equalToConstant: 150),
            
            addButton.leadingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: 10),
            addButton.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor),
            
            spinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20)
        ])
    }
    
    // Add a new name to the list and redraw the wheel
    @objc func addName() {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        names.append(name)
        nameTextField.text = ""
        drawWheel() // Redraw the wheel with the new name
    }
    
    // Spin the wheel and choose a random name
    @objc func spinWheel() {
        guard !names.isEmpty else {
            let alert = UIAlertController(title: "No Names", message: "Please add names before spinning the wheel.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let randomRotation = CGFloat(arc4random_uniform(360)) + 720 // Spin at least twice
        let duration = 3.0
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = (randomRotation * CGFloat.pi) / 180
        rotationAnimation.duration = duration
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.fillMode = .forwards
        wheelImageView.layer.add(rotationAnimation, forKey: "spinAnimation")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.showRandomName()
        }
    }
    
    // Show a random name as the result
    func showRandomName() {
        guard let chosenName = names.randomElement() else { return }
        let alert = UIAlertController(title: "Congratulations!", message: "\(chosenName) was chosen!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Draw the wheel with each person's name in a unique colored segment
    func drawWheel() {
        let size = CGSize(width: 300, height: 300)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = size.width / 2
        let angleIncrement = CGFloat(2 * Double.pi) / CGFloat(names.count)

        
        for (index, name) in names.enumerated() {
            // Generate a random color for each segment
            let color = UIColor(hue: CGFloat(index) / CGFloat(names.count), saturation: 0.8, brightness: 0.9, alpha: 1.0)
            color.setFill()
            
            // Calculate start and end angles for the segment
            let startAngle = angleIncrement * CGFloat(index)
            let endAngle = startAngle + angleIncrement
            
            // Draw the segment
            context.move(to: center)
            context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            context.closePath()
            context.fillPath()
            
            // Add the person's name as text on the segment
            let textAngle = (startAngle + endAngle) / 2
            let textPosition = CGPoint(
                x: center.x + (radius * 0.7) * cos(textAngle) - 20,
                y: center.y + (radius * 0.7) * sin(textAngle) - 10
            )
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.white
            ]
            name.draw(at: textPosition, withAttributes: attributes)
        }
        
        wheelImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

struct WheelViewController_Preview: PreviewProvider {
    static var previews: some View {
        // Use UIViewControllerPreview to display WheelViewController in Canvas
        WheelViewControllerPreview()
            .edgesIgnoringSafeArea(.all)
    }
}

// Helper struct to wrap UIViewController in SwiftUI
struct WheelViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> WheelViewController {
        return WheelViewController()
    }
    
    func updateUIViewController(_ uiViewController: WheelViewController, context: Context) {}
}
