//
//  ViewController.swift
//  Hospital AR
//
//  Created by YS on 4/10/19.
//  Copyright © 2019 YS. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AudioToolbox

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    var sceneView: VirtualObjectARView!
    
    /// A serial queue for thread safety when modifying the SceneKit node graph.
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".serialSceneKitQueue")
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    let arLogo = LogoView()
    
    lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView)
    
    var cutButton = UIButton.interfaceButton()
    
    var backButton = UIButton.interfaceButton()
    
    var changerSwitch = UISwitch()
    
    var tappedNodes = [SCNNode]()
    
    var nodesDict = [Int : SCNNode]()
    
    var nodesArray = [SCNNode]()
    
    var configType = ConfigType.imageTracking
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init sceneView
        sceneView = VirtualObjectARView(frame: view.bounds)
//        sceneView.
//        sceneView.translatesAutoresizingMaskIntoConstraints = false
        
        
        // Add Subview sceneView
        self.view.addSubview(sceneView)
        
        // Set Constraints sceneView
//        sceneView.centerXAnchor.constraint(equalTo: self.view.layoutMarginsGuide.centerXAnchor).isActive = true
//        sceneView.centerYAnchor.constraint(equalTo: self.view.layoutMarginsGuide.centerYAnchor).isActive = true
        
    
        addARLogo()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        
        // Init Buttons
        cutButton.addTarget(self, action: #selector(cutAction), for: .touchUpInside)
        cutButton.setTitle("Cut", for: .normal)
        cutButton.translatesAutoresizingMaskIntoConstraints = false
        cutButton.isHidden = true
        
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton.setTitle("Back", for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.isHidden = true
        
        changerSwitch.addTarget(self, action: #selector(switchIsChanged(sender:)), for: .valueChanged)
        changerSwitch.isOn = true
        changerSwitch.translatesAutoresizingMaskIntoConstraints = false
        changerSwitch.layer.opacity = 0.5
        changerSwitch.onTintColor = UIColor(red: 64.0/255.0, green: 188.0/255.0, blue: 156.0/255.0, alpha: 1.0/1.0)
        changerSwitch.tintColor = UIColor(red: 188.0/255.0, green: 126.0/255.0, blue: 64.0/255.0, alpha: 1.0/1.0)
        
        /// Add Subview Buttons
        self.view.addSubview(cutButton)
        self.view.addSubview(backButton)
        self.view.addSubview(changerSwitch)
        
        /// Set Constraints Buttons
        let margin = self.view.layoutMarginsGuide
        
        cutButton.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 20).isActive = true
        cutButton.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -50).isActive = true
        
        backButton.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -20).isActive = true
        backButton.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -50).isActive = true
        
        changerSwitch.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -20).isActive = true
        changerSwitch.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -20).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent the screen from being dimmed to avoid interupping the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Start the AR experience
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    /// - Tag: Solve sceneView rotation problem
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        var rotation = Float()
        
        if toInterfaceOrientation == .portrait {
            rotation = 0
        } else
            if toInterfaceOrientation == .landscapeLeft {
                rotation = Float.pi/2
            } else
                if toInterfaceOrientation == .landscapeRight {
                    rotation = -Float.pi/2
        }
        
        UIView.animate(withDuration: duration, animations: {
            self.sceneView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
            self.sceneView.frame = self.view.frame
            self.sceneView.bounds = self.view.bounds
        })
    }
    
    // MARK: - Session management (Image detection setup)

    /// Prevent restarting the session while a restart is in progress.
    var isRestartAvailable = true
    
    /// Create a new AR configuration to run on the 'session'.
    /// - Tag: ARReferenceImage-Loading
    func resetTracking() {
        if configType == .worldTracking {
            guard let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "AR Objects", bundle: nil) else {
                fatalError("Missing expected asset catalog resources.")
            }
            
            let worldTrackingConfiguration = ARWorldTrackingConfiguration()
            worldTrackingConfiguration.detectionObjects = referenceObjects
            session.run(worldTrackingConfiguration, options: [.resetTracking, .removeExistingAnchors])
        } else {
            guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
                fatalError("Missing expected asset catalog resources.")
            }
            
            let imageTrackingConfiguration = ARImageTrackingConfiguration()
            imageTrackingConfiguration.trackingImages = referenceImages
            session.run(imageTrackingConfiguration, options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
    func addARLogo() {
        // Add AR Logo
        self.view.addSubview(arLogo)
        
        arLogo.translatesAutoresizingMaskIntoConstraints = false
        
        arLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        arLogo.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    @objc func switchIsChanged(sender: UISwitch) {
        if sender.isOn {
            configType = ConfigType.imageTracking
            arLogo.label.text = "识别图片"
            arLogo.logoImage.image = UIImage(named: "arLogo")
        } else {
            configType = ConfigType.worldTracking
            arLogo.label.text = "识别物体"
            arLogo.logoImage.image = UIImage(named: "arLogoObject")
        }
        resetTracking()
        
        if arLogo.isHidden {
            arLogo.isHidden = false
        }
        
        nodesArray.removeAll()
        nodesDict.removeAll()
    }
     
}

