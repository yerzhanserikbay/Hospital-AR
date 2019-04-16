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
    
    weak var blurView: UIVisualEffectView!
    
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
    
    var tappedNodes = [SCNNode]()
    
    var dictNodes = [Int : SCNNode]()
    
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = VirtualObjectARView(frame: view.bounds)
        self.view.addSubview(sceneView)
    
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
        
        /// Add Subview Buttons
        
        self.view.addSubview(cutButton)
        self.view.addSubview(backButton)
        
        /// Constraint Buttons
        
        let margin = self.view.layoutMarginsGuide
        
        cutButton.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 20).isActive = true
        cutButton.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -50).isActive = true
        
        backButton.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -20).isActive = true
        backButton.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -50).isActive = true
        
       
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
    
    
    // MARK: - Session management (Image detection setup)

    /// Prevent restarting the session while a restart is in progress.
    var isRestartAvailable = true
    
    /// Create a new AR configuration to run on the 'session'.
    /// - Tag: ARReferenceImage-Loading
    func resetTracking() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = referenceImages
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func addARLogo() {
        // Add AR Logo
        self.view.addSubview(arLogo)
        
        arLogo.translatesAutoresizingMaskIntoConstraints = false
        
        arLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        arLogo.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
     
}

