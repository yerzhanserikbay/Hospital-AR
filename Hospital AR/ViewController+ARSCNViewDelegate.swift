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
        if let imageAnchor = anchor as? ARImageAnchor {
            let imageName = imageAnchor.referenceImage.name
            if imageName == "anatomyBuilding" {
                DispatchQueue.main.async {
                    self.presentInfoViewController(object: imageName!)
                }
            } else {
                handleFoundImage(node)
            }
        } else if anchor is ARObjectAnchor {
            handleFoundObject(node)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first?.location(in: sceneView),
            let hitNode = sceneView?.hitTest(touchLocation, options: nil).first?.node,
            let nodeName = hitNode.name
            else {
                nodesDict[0]?.childNode(withName: "Hand_R", recursively: true)?.opacity = 1.0
                nodesDict[0]?.childNode(withName: "Arm_R", recursively: true)?.opacity = 1.0
                backButton.isHidden = true
                cutButton.isHidden = true
                return
        }
        
        /// Handle a touch then call function
        
        // Object detection
        func setupInterface(for status: Animate) {
            animateNodes(nodesArray.last!, animate: status)
            removeNodesFromParent(in: nodesArray.last!, after: status)
            addButtons(to: nodesArray.last!, when: status)
        }
        
        print("\(nodeName) is touched")
        
        switch nodeName {
        case "heartButton":
            setupInterface(for: .unhide)
            return
        case "openButton":
            presentInfoViewController(object: "Heart")
            return
        case "hideButton":
            setupInterface(for: .hide)
            return
        default:
           break
        }
    
        // Image Detection
        if nodeName == "Arm" || nodeName == "Hand" {
            presentInfoViewController(object: nodeName)
            return
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
            
            nodesDict[0]?.childNode(withName: name, recursively: true)?.opacity = 0.5
            
            nodesDict[0]?.childNode(withName: nodeName, recursively: true)?.opacity = 1.0
            return
        }
    }
    
    // MARK: - Custom Methods
    
    /// - Tag: Function that calls when an object is found
    func handleFoundObject(_ node: SCNNode) {
        
        addScene(object: "Skeleton.scn", to: node, withArrow: false, set: nil)
        
        addScene(object: "Heart/HumanHeart.scn", to: node, withArrow: false, set: (position: SCNVector3(-0.005, 0.116, 0.296),
                                                                                   scale: SCNVector3(2.5, 2.5, 2.5),
                                                                                   eular: SCNVector3(-Float.pi/2, 0, Float.pi/2)))
        
        addButtons(to: nodesArray.last!, when: .hide)
    }
    
    /// - Tag: Function that calls when an image is found
    func handleFoundImage(_ node: SCNNode) {
        updateQueue.async {
            self.addScene(object: "/Bone/bone.scn", to: node, withArrow: true, set: nil)
        }
    }
    
    /// - Tag: Function that animates nodes
    func animateNodes(_ node: SCNNode, animate: Animate) {
        
        guard animate == .unhide else {
            // Hide Animation
            let zoomAction = SCNAction.scale(to: 2.5, duration: 0.2)
            zoomAction.timingMode = .easeInEaseOut
            
            let moveAction = SCNAction.move(by: SCNVector3(0, -0.3, 0), duration: 0.2)
            moveAction.timingMode = .easeInEaseOut
            
            let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat.pi/2, z: 0, duration: 0.2)
            rotateAction.timingMode = .easeInEaseOut
            
            let actionSequence = SCNAction.sequence([moveAction, rotateAction, zoomAction])
            
            node.runAction(actionSequence)
            return
        }
        
        // Unhide Animation
        let zoomAction = SCNAction.scale(to: 4, duration: 0.2)
        zoomAction.timingMode = .easeInEaseOut
        
        let moveAction = SCNAction.move(by: SCNVector3(0, 0.3, 0), duration: 0.2)
        moveAction.timingMode = .easeInEaseOut
        
        let rotateAction = SCNAction.rotateBy(x: 0, y: -CGFloat.pi/2, z: 0, duration: 0.2)
        rotateAction.timingMode = .easeInEaseOut
        
        let actionSequence = SCNAction.sequence([moveAction, rotateAction, zoomAction])
        
        node.runAction(actionSequence)
        
//        let pointNode = node.childNode(withName: "Point", recursively: true)
//
//        let fadeInAction = SCNAction.fadeOpacity(to: 0.4, duration: 0.5)
//        fadeInAction.timingMode = .easeInEaseOut
//
//        let fadeOutAction = SCNAction.fadeOpacity(to: 1.0, duration: 0.5)
//        fadeOutAction.timingMode = .easeInEaseOut
//
//        let fadeActionSequence = SCNAction.sequence([fadeInAction, fadeOutAction])
//
//        let foreverRepeated = SCNAction.repeatForever(fadeActionSequence)
//
//        pointNode?.runAction(foreverRepeated)
    }
    
    /// - Tag: Function that removes nodes [heartButton, Line, Point or hideButton, openButton]
    func removeNodesFromParent(in node: SCNNode, after status: Animate) {
        guard status == .unhide else {
            let hideButtonNode = node.childNode(withName: "hideButton", recursively: true)
            hideButtonNode?.removeFromParentNode()
            
            let openButtonNode = node.childNode(withName: "openButton", recursively: true)
            openButtonNode?.removeFromParentNode()
            
            return
        }
        
        let heartButtonNode = node.childNode(withName: "heartButton", recursively: true)
        heartButtonNode?.removeFromParentNode()
        
        let lineNode = node.childNode(withName: "Line", recursively: true)
        lineNode?.removeFromParentNode()
        
        let pointNode = node.childNode(withName: "Point", recursively: true)
        pointNode?.removeFromParentNode()
    }
    
    /// - Tag: Function that adds buttons [Hide, Open]
    func addButtons(to node: SCNNode, when status: Animate) {
        guard status == .unhide else {
            // Hide
            addCustomPoint(to: node, pointName: "", set: (position: SCNVector3(0.02, 0.0, 0),
                                                          scale: SCNVector3(0.009, 0.009, 0.01),
                                                          eular: SCNVector3(-Float.pi/2, Float.pi/2, 0)))
            
            addCustomButton(to: node, labelName: "心脏", set: (position: SCNVector3(0.06, 0.0, 0),
                                                                scale: SCNVector3(0.0045, 0.0045, 0.01),
                                                                eular: SCNVector3(-Float.pi/2, Float.pi/2, 0)))
            
            let lineNode = SCNNode()
            lineNode.name = "Line"
            nodesArray.last!.addChildNode(lineNode.buildLineNode(from: SCNVector3(0.02, 0.0, 0),
                                                                 to: SCNVector3(0.055, 0.0, 0),
                                                                 radius: 0.0001,
                                                                 color: .white))
            return
        }
        // Unhide
        addCustomButton(to: node, labelName: "隐藏", set: (position: SCNVector3(0.0, 0.0, -0.05),
                                                           scale: SCNVector3(0.0045, 0.0045, 0.01),
                                                           eular: SCNVector3(-Float.pi, Float.pi/2, 0)))
        
        addCustomButton(to: node, labelName: "打开", set: (position: SCNVector3(0.0, 0.0, 0.05),
                                                           scale: SCNVector3(0.0045, 0.0045, 0.01),
                                                           eular: SCNVector3(-Float.pi, Float.pi/2, 0)))
    }
    
    /// - Tag: Function that adds a scene with object to the node. Can set position, scale and eular
    func addScene(object path: String, to node: SCNNode, withArrow: Bool, set: (position: SCNVector3, scale: SCNVector3, eular: SCNVector3)?) {
        let newNode = VirtualObject()
        
        updateQueue.async {
            let objectPath = "art.scnassets/\(path)"
            guard let virtualObjectScene = SCNScene(named: objectPath) else {
                print("Unable to Generate " + objectPath)
                return
            }
            
            for child in virtualObjectScene.rootNode.childNodes {
                child.geometry?.firstMaterial?.lightingModel = .physicallyBased
                newNode.addChildNode(child)
            }
            
            if set != nil {
                newNode.position = set!.position
                newNode.scale = set!.scale
                newNode.eulerAngles = set!.eular
            }
            
            newNode.name = path.components(separatedBy: "/").last
            
            node.addChildNode(newNode)
            
            if withArrow == true {
                var i = 0
                for node in newNode.childNodes {
                    self.nodesDict[i] = node
                    i += 1
                }
                
                i = 0
                
                for node in self.nodesDict[i]!.childNodes {
                    
                    self.addPoint(to: node)
                    self.addButton(to: node)
                    
                    let lineNode = SCNNode()
                    
                    node.addChildNode(lineNode.buildLineNode(from: SCNVector3(-1.0, 0.8, 2.5),
                                                             to: SCNVector3(-16.0, 0.6, 5.0),
                                                             radius: 0.1,
                                                             color: .white))
                    i += 1
                }
                
                self.virtualObjectInteraction.selectedObject = self.centerPivot(for: newNode)
            }
        }
        self.nodesArray.append(newNode)
    }
    
    func addCustomButton(to node: SCNNode, labelName: String, set: (position: SCNVector3, scale: SCNVector3, eular: SCNVector3)) {
        let buttonSkScene = SKScene(size: CGSize(width: 1000, height: 400))
        buttonSkScene.backgroundColor = UIColor.white
        
        let labelNode = SKLabelNode(text: labelName)

        labelNode.position = CGPoint(x: 450, y: 120)
        labelNode.fontSize = 300
        labelNode.fontName = "GillSans"
        labelNode.fontColor = UIColor.black
        
        buttonSkScene.addChild(labelNode)
        
        let button = SCNPlane(width: 10, height: 4)
        button.firstMaterial?.diffuse.contents = buttonSkScene
        
        button.cornerRadius = button.height / 2
        button.firstMaterial?.isDoubleSided = true
        
        let buttonNode = SCNNode(geometry: button)
        buttonNode.position = set.position
        
        buttonNode.scale = set.scale
        
        buttonNode.eulerAngles.x = set.eular.x
        buttonNode.eulerAngles.y = set.eular.y
        
        buttonNode.geometry?.materials.first?.lightingModel = .constant
        
        var engLabelName = String()
        
        switch labelName {
        case "心脏":
            engLabelName = "Heart"
        case "隐藏":
            engLabelName = "Hide"
        case "打开":
            engLabelName = "Open"
        default:
            engLabelName = labelName
        }
        
        buttonNode.name = "\(engLabelName.lowercased())Button"
        
        nodesArray.last!.addChildNode(buttonNode)
    }
    
    func addCustomPoint(to node: SCNNode, pointName: String, set: (position: SCNVector3, scale: SCNVector3, eular: SCNVector3)) {
        let ovalSkScene = SKScene(size: CGSize(width: 1, height: 1.5))
        ovalSkScene.backgroundColor = UIColor.white
        
        let plane = SCNPlane(width: 1, height: 1)
        plane.firstMaterial?.diffuse.contents = ovalSkScene
        plane.firstMaterial?.isDoubleSided = true
        plane.cornerRadius = plane.width/2
        
        let ovalNode = SCNNode(geometry: plane)
        
        ovalNode.geometry?.materials.first?.lightingModel = .constant
        
        ovalNode.position = set.position
        ovalNode.scale = set.scale
        ovalNode.eulerAngles.y = set.eular.y
        
        ovalNode.name = "\(pointName.lowercased())Point"
        
        nodesArray.last!.addChildNode(ovalNode)
    }
    
    /// - Tag: Function that cuts a node
    @objc func cutAction() {
        tappedNodes.last?.isHidden = true
    }
    
    /// - Tag: Function that restores last deleted node
    @objc func backAction() {
        guard !tappedNodes.isEmpty else { return }
        tappedNodes.last?.isHidden = false
        tappedNodes.removeLast()
    }
    
    /// - Tag: Function that adds point to a node
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
    
    /// - Tag: Function that adds button to a node
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
    
    /// - Tag: Function that presents InfoViewController and send object's name
    func presentInfoViewController(object: String) {
        AudioServicesPlaySystemSound(SystemSoundID(1519))
        let infoViewController = InfoViewController()
        infoViewController.objectName = object
        infoViewController.modalTransitionStyle = .crossDissolve
        infoViewController.modalPresentationStyle = .overCurrentContext
        self.present(infoViewController, animated: true, completion: nil)
    }
    
    /// - Tag: Function that returns a node with center pivot
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
