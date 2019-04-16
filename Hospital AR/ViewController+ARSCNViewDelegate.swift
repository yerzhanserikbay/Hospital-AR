//
//  ViewController+ARSCNViewDelegate.swift
//  Hospital AR
//
//  Created by YS on 4/15/19.
//  Copyright © 2019 YS. All rights reserved.
//

import ARKit

extension ViewController: ARSCNViewDelegate {
    
    // MARK: = ARSCNViewDelegate (Image detection results)
    /// - Tag: ARImageAnchor-Visualizing
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        //        let referenceImage = imageAnchor.referenceImage
        
        updateQueue.async {
            
            let objectPath = "art.scnassets/Bone/bone.scn"
            guard let virtualObjectScene = SCNScene(named: objectPath) else {
                print("Unable to Generate " + objectPath)
                return
            }
            
            let boneNode = VirtualObject()
            
            for child in virtualObjectScene.rootNode.childNodes {
                child.geometry?.firstMaterial?.lightingModel = .physicallyBased
                boneNode.addChildNode(child)
            }
            
            node.addChildNode(boneNode)
        
            var i = 0
            for node in boneNode.childNodes {
                self.dictNodes[i] = node
                i += 1
            }
            
            i = 0
            
            for node in self.dictNodes[i]!.childNodes {
                
                self.addPoint(to: node)
                self.addButton(to: node)
                
                let lineNode = SCNNode()
                
                node.addChildNode(lineNode.buildLineNode(from: SCNVector3(-1.0, 0.8, 2.5),
                                                         to: SCNVector3(-16.0, 0.6, 5.0),
                                                         radius: 0.1,
                                                         color: .white))
                i += 1
            }
            
            self.virtualObjectInteraction.selectedObject = self.centerPivot(for: boneNode)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        guard let touchLocation = touches.first?.location(in: sceneView),
            let hitNode = sceneView?.hitTest(touchLocation, options: nil).first?.node,
            let nodeName = hitNode.name
            else {
                dictNodes[0]?.childNode(withName: "Hand_R", recursively: true)?.opacity = 1.0
                dictNodes[0]?.childNode(withName: "Arm_R", recursively: true)?.opacity = 1.0
                backButton.isHidden = true
                cutButton.isHidden = true
                return
                
        }
        
        //Handle Event Here e.g. PerformSegue
        if nodeName == "Arm" || nodeName == "Hand" {
            showInfoViewController(object: nodeName)
        }
        
        if nodeName == "Arm_R" || nodeName == "Hand_R" {
            
            if tappedNodes.count > 3 {
                tappedNodes.remove(at: 0)
            }
            
            tappedNodes.append(hitNode)
            
            var name = String()
            
            if nodeName == "Arm_R" {
                name = "Hand_R"
            } else {
                name = "Arm_R"
            }
            
            backButton.isHidden = false
        
            cutButton.isHidden = false
            
            dictNodes[0]?.childNode(withName: name, recursively: true)?.opacity = 0.5

            dictNodes[0]?.childNode(withName: nodeName, recursively: true)?.opacity = 1.0
            
        }
    }
    
    // MARK: - Custom Methods
    
    @objc func cutAction() {
        tappedNodes.last?.isHidden = true
    }
    
    @objc func backAction() {
        guard !tappedNodes.isEmpty else { return }
        tappedNodes.last?.isHidden = false
        tappedNodes.removeLast()
    }
    
    func addPoint(to node: SCNNode) {
        
        let ovalSkScene = SKScene(size: CGSize(width: 1000, height: 1500))
        ovalSkScene.backgroundColor = UIColor.white
        
        let plane = SCNPlane(width: 3, height: 3)
        plane.firstMaterial?.diffuse.contents = ovalSkScene
        plane.firstMaterial?.isDoubleSided = true
        plane.cornerRadius = plane.width/2
        
        let ovalNode = SCNNode(geometry: plane)
        
        let x = node.childNodes.first?.position.x ?? 0
        let y = node.childNodes.first?.position.y ?? 0
        let z = node.childNodes.first?.position.z ?? 0
        
        ovalNode.position = SCNVector3(x-1, y+0.8, z+2.5)
        ovalNode.name = "Point"
        
        node.addChildNode(ovalNode)
    }
    
    func addButton(to node: SCNNode) {
        
        let buttonSkScene = SKScene(size: CGSize(width: 1000, height: 400))
        buttonSkScene.backgroundColor = UIColor.white
        
        let x = node.childNodes.first?.position.x ?? 0
        let y = node.childNodes.first?.position.y ?? 0
        let z = node.childNodes.first?.position.z ?? 0
        
        let text = node.name?.components(separatedBy: "_")
        let labelNode = SKLabelNode(text: text?[0] ?? "Null")
        // y + up x + right
        labelNode.position = CGPoint(x: 450, y: 120)
        labelNode.fontSize = 300
        labelNode.fontName = "GillSans"
        labelNode.fontColor = UIColor.black
        
        
        buttonSkScene.addChild(labelNode)
        
        let button = SCNPlane(width: 10, height: 4)
        button.firstMaterial?.diffuse.contents = buttonSkScene
        //        plane.firstMaterial?.isDoubleSided = true
        button.cornerRadius = button.height / 2
        button.firstMaterial?.isDoubleSided = true
        
        let buttonNode = SCNNode(geometry: button)
        buttonNode.position = SCNVector3(x-15, y+0.8, z+2.5)
        buttonNode.eulerAngles.x = Float.pi
        
        buttonNode.name = text?[0] ?? "Null"
        
        node.addChildNode(buttonNode)
    }
    
    func showInfoViewController(object: String) {
        AudioServicesPlaySystemSound(SystemSoundID(1519))
        let infoViewController = InfoViewController()
        infoViewController.objectName = object
        infoViewController.modalTransitionStyle = .crossDissolve
        infoViewController.modalPresentationStyle = .overCurrentContext
        self.present(infoViewController, animated: true, completion: nil)
    }
    
    func centerPivot(for node: SCNNode) -> SCNNode {
        var min = SCNVector3Zero
        var max = SCNVector3Zero
        node.__getBoundingBoxMin(&min, max: &max)
        node.pivot = SCNMatrix4MakeTranslation(
            min.x + (max.x - min.x)/2,
            min.y + (max.y - min.y)/2,
            min.z + (max.z - min.z)/2
        )
        return node
    }
}
