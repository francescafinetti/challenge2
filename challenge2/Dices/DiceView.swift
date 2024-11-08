//
//  DiceView.swift
//  challenge2
//
//  Created by Francesca Finetti on 07/11/24.
//

import SwiftUI
import SceneKit

struct DiceView: UIViewRepresentable {
    @Binding var isRolling: Bool
    @Binding var diceCount: Int
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.allowsCameraControl = true
        sceneView.scene = createDiceScene()
        sceneView.backgroundColor = .white
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
            print("Faccia selezionata Dado 1: \(randomFace1), Dado 2: \(randomFace2), Dado 3: \(randomFace3)")
            context.coordinator.stopOnFaces(randomFace1, randomFace2, randomFace3)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    private func createDiceScene() -> SCNScene {
        let scene = SCNScene()
        
       
        let diceNode1 = createDiceNode(name: "diceNode1")
        scene.rootNode.addChildNode(diceNode1)
        
        let diceNode2 = createDiceNode(name: "diceNode2")
        diceNode2.isHidden = true
        scene.rootNode.addChildNode(diceNode2)
        
        let diceNode3 = createDiceNode(name: "diceNode3")
        diceNode3.isHidden = true
        scene.rootNode.addChildNode(diceNode3)
        
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(5, 5, 5)
        scene.rootNode.addChildNode(lightNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 5)
        scene.rootNode.addChildNode(cameraNode)
        
        return scene
    }
    
    private func createDiceNode(name: String) -> SCNNode {
        let dice = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.1)
        let diceSymbols = ["die.face.1", "die.face.2", "die.face.3", "die.face.4", "die.face.5", "die.face.6"]
        let diceMaterials = diceSymbols.map { symbolName -> SCNMaterial in
            let material = SCNMaterial()
            material.diffuse.contents = createSymbolImage(symbolName: symbolName)
            return material
        }
        
        dice.materials = diceMaterials
        
        let diceNode = SCNNode(geometry: dice)
        diceNode.name = name
        return diceNode
    }
    
    private func createSymbolImage(symbolName: String) -> UIImage? {
        let configuration = UIImage.SymbolConfiguration(pointSize: 80, weight: .bold, scale: .large)
        return UIImage(systemName: symbolName, withConfiguration: configuration)
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
            switch diceCount {
            case 1:
                diceNode1?.position = SCNVector3(0, 0, 0)
                diceNode1?.isHidden = false
                diceNode2?.isHidden = true
                diceNode3?.isHidden = true
            case 2:
                diceNode1?.position = SCNVector3(-0.8, 0, 0)
                diceNode2?.position = SCNVector3(0.8, 0, 0)
                diceNode1?.isHidden = false
                diceNode2?.isHidden = false
                diceNode3?.isHidden = true
            case 3:
                diceNode1?.position = SCNVector3(-1.5, 0, 0)
                diceNode2?.position = SCNVector3(1.5, 0, 0)
                diceNode3?.position = SCNVector3(0, 0, 0)
                diceNode1?.isHidden = false
                diceNode2?.isHidden = false
                diceNode3?.isHidden = false
            default:
                break
            }
        }
        
        func startRolling() {
            guard let diceNode1 = diceNode1 else { return }
            
            let rotationAnimation1 = CABasicAnimation(keyPath: "rotation")
            rotationAnimation1.fromValue = diceNode1.rotation
            rotationAnimation1.toValue = SCNVector4(x: 1, y: 1, z: 1, w: Float.pi * 8)
            rotationAnimation1.duration = 0.5
            rotationAnimation1.repeatCount = .infinity
            diceNode1.addAnimation(rotationAnimation1, forKey: "roll1")
            
            if let diceNode2 = diceNode2, !diceNode2.isHidden {
                let rotationAnimation2 = CABasicAnimation(keyPath: "rotation")
                rotationAnimation2.fromValue = diceNode2.rotation
                rotationAnimation2.toValue = SCNVector4(x: -1, y: -1, z: 1, w: Float.pi * 8)
                rotationAnimation2.duration = 0.5
                rotationAnimation2.repeatCount = .infinity
                diceNode2.addAnimation(rotationAnimation2, forKey: "roll2")
            }
            
            if let diceNode3 = diceNode3, !diceNode3.isHidden {
                let rotationAnimation3 = CABasicAnimation(keyPath: "rotation")
                rotationAnimation3.fromValue = diceNode3.rotation
                rotationAnimation3.toValue = SCNVector4(x: 1, y: -1, z: -1, w: Float.pi * 8)
                rotationAnimation3.duration = 0.5
                rotationAnimation3.repeatCount = .infinity
                diceNode3.addAnimation(rotationAnimation3, forKey: "roll3")
            }
        }
        
        func stopOnFaces(_ face1: Int, _ face2: Int, _ face3: Int) {
            guard let diceNode1 = diceNode1 else { return }
            diceNode1.removeAllAnimations()
            
            let faceRotations: [Int: SCNVector4] = [
                1: SCNVector4(1, 0, 0, Float.pi / 2),
                2: SCNVector4(0, 0, 1, Float.pi),
                3: SCNVector4(1, 0, 0, -Float.pi / 2),
                4: SCNVector4(0, 0, 1, Float.pi / 2),
                5: SCNVector4(0, 0, 1, -Float.pi / 2),
                6: SCNVector4(1, 0, 0, 0)
            ]
            
            if let rotation1 = faceRotations[face1] {
                diceNode1.rotation = rotation1
            }
            
            if let diceNode2 = diceNode2, !diceNode2.isHidden {
                diceNode2.removeAllAnimations()
                if let rotation2 = faceRotations[face2] {
                    diceNode2.rotation = rotation2
                }
            }
            
            if let diceNode3 = diceNode3, !diceNode3.isHidden {
                diceNode3.removeAllAnimations()
                if let rotation3 = faceRotations[face3] {
                    diceNode3.rotation = rotation3
                }
            }
        }
    }
}
