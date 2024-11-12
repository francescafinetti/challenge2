import SwiftUI
import SceneKit

struct DiceView: UIViewRepresentable {
    @Binding var isRolling: Bool
    @Binding var diceCount: Int
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.allowsCameraControl = false
        sceneView.backgroundColor = UIColor.clear
        sceneView.scene = createDiceScene()
        context.coordinator.setup(sceneView: sceneView)
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        context.coordinator.updateDicePositions(diceCount: diceCount)
        if isRolling {
            context.coordinator.startRolling()
        } else {
            let randomFace1 = Int.random(in: 1...6)
            let randomFace2 = Int.random(in: 1...6)
            let randomFace3 = Int.random(in: 1...6)
            print("Selected Face - Dice 1: \(randomFace1), Dice 2: \(randomFace2), Dice 3: \(randomFace3)")
            context.coordinator.stopOnFaces(randomFace1, randomFace2, randomFace3)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    private func createDiceScene() -> SCNScene {
        let scene = SCNScene()
        
        // Carica i dadi dal file .usdz
        let diceNode1 = createDiceNode(name: "diceNode1")
        scene.rootNode.addChildNode(diceNode1)
        
        let diceNode2 = createDiceNode(name: "diceNode2")
        diceNode2.isHidden = true
        scene.rootNode.addChildNode(diceNode2)
        
        let diceNode3 = createDiceNode(name: "diceNode3")
        diceNode3.isHidden = true
        scene.rootNode.addChildNode(diceNode3)
        
        // Aggiungi luci per migliorare la visibilità
        addOmniLight(to: scene)
        
        // Aggiungi una fotocamera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 100)
        scene.rootNode.addChildNode(cameraNode)
        
        return scene
    }
    
    private func addOmniLight(to scene: SCNScene) {
        // Luce omnidirezionale principale
        let omniLight = SCNLight()
        omniLight.type = .omni
        omniLight.type = .omni
        omniLight.intensity = 0
        omniLight.color = UIColor.white
        let omniLightNode = SCNNode()
        omniLightNode.light = omniLight
        omniLightNode.position = SCNVector3(10, 10, 0)
        scene.rootNode.addChildNode(omniLightNode)
        
        // Luce ambientale per ammorbidire le ombre
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 10000
        ambientLight.color = UIColor.darkGray
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)

    }
    
    
    
    private func createDiceNode(name: String) -> SCNNode {
        guard let diceScene = SCNScene(named: "Dice.scn"),
              let diceNode = diceScene.rootNode.childNodes.first else {
            print("Error: Unable to load Dice.usdz")
            return SCNNode()
        }
        
        diceNode.name = name
        diceNode.scale = SCNVector3(0.1, 0.1, 0.1)
        diceNode.position = SCNVector3(0, 0, 0)
        return diceNode
    }
    
    class Coordinator: NSObject {
        private weak var sceneView: SCNView?
        private var diceNode1: SCNNode?
        private var diceNode2: SCNNode?
        private var diceNode3: SCNNode?
        
        func setup(sceneView: SCNView) {
            self.sceneView = sceneView
            self.diceNode1 = sceneView.scene?.rootNode.childNode(withName: "diceNode1", recursively: true)
            self.diceNode2 = sceneView.scene?.rootNode.childNode(withName: "diceNode2", recursively: true)
            self.diceNode3 = sceneView.scene?.rootNode.childNode(withName: "diceNode3", recursively: true)
        }
        
        func updateDicePositions(diceCount: Int) {
            let spacing: Float = 18 // Distanza tra i dadi per evitare sovrapposizioni
            switch diceCount {
            case 1:
                diceNode1?.position = SCNVector3(0, 0, 0)
                diceNode1?.isHidden = false
                diceNode2?.isHidden = true
                diceNode3?.isHidden = true
            case 2:
                diceNode1?.position = SCNVector3(-spacing, 0, 0)
                diceNode2?.position = SCNVector3(spacing, 0, 0)
                diceNode1?.isHidden = false
                diceNode2?.isHidden = false
                diceNode3?.isHidden = true
            case 3:
                diceNode1?.position = SCNVector3(-spacing * 1.5, 0, 0)
                diceNode2?.position = SCNVector3(0, 0, 0)
                diceNode3?.position = SCNVector3(spacing * 1.5, 0, 0)
                diceNode1?.isHidden = false
                diceNode2?.isHidden = false
                diceNode3?.isHidden = false
            default:
                break
            }
        }

        
        func startRolling() {
            [diceNode1, diceNode2, diceNode3].forEach { diceNode in
                guard let diceNode = diceNode, !diceNode.isHidden else { return }
                
                let rotationAnimation = CABasicAnimation(keyPath: "rotation")
                rotationAnimation.fromValue = diceNode.rotation
                rotationAnimation.toValue = SCNVector4(x: 1, y: 1, z: 1, w: Float.pi * 8)
                rotationAnimation.duration = 1.5
                rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
                rotationAnimation.repeatCount = .infinity
                diceNode.addAnimation(rotationAnimation, forKey: "roll")
            }
        }
        
        func stopOnFaces(_ face1: Int, _ face2: Int, _ face3: Int) {
            [diceNode1, diceNode2, diceNode3].enumerated().forEach { index, diceNode in
                guard let diceNode = diceNode, !diceNode.isHidden else { return }
                diceNode.removeAllAnimations()
                
                let faceRotations: [Int: SCNVector4] = [
                    1: SCNVector4(1, 0, 0, Float.pi / 2),
                    2: SCNVector4(0, 0, 1, Float.pi),
                    3: SCNVector4(1, 0, 0, -Float.pi / 2),
                    4: SCNVector4(0, 0, 1, Float.pi / 2),
                    5: SCNVector4(0, 0, 1, -Float.pi / 2),
                    6: SCNVector4(1, 0, 0, 0)
                ]
                
                let face = [face1, face2, face3][index]
                if let rotation = faceRotations[face] {
                    diceNode.rotation = rotation
                }
            }
        }
    }
}

#Preview {
    Dices()
}
