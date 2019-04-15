//
//  VirtualObjectInteraction.swift
//  Hospital AR
//
//  Created by YS on 4/15/19.
//  Copyright © 2019 YS. All rights reserved.
//

import UIKit
import ARKit

class VirtualObjectInteraction: NSObject, UIGestureRecognizerDelegate {
    let sceneView: VirtualObjectARView
    
    var selectedObject: SCNNode?
    
    private var currentTrackingPosition: CGPoint?
    
    init(sceneView: VirtualObjectARView) {
        self.sceneView = sceneView
        super.init()
        
        let rotateGesture = UIPanGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        rotateGesture.delegate = self
        DispatchQueue.main.async {
            sceneView.addGestureRecognizer(rotateGesture)
        }
    }
    
    @objc func didRotate(_ gesture: UIPanGestureRecognizer) {
        guard let node = selectedObject else {
            return
        }
        
        // Add alightments
        let vel = gesture.velocity(in: sceneView)
        let xPan = gesture.velocity(in: sceneView).x/10000

        
        if gesture.state == .changed {
            // Rotation
            if abs(vel.x) > abs(vel.y) {
                node.runAction(SCNAction.rotateBy(x: 0, y: 0, z: xPan, duration: 0.01))
            }
        }
    }
    
}
