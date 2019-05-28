//
//  ViewController+ARSessionDelegate.swift
//  Hospital AR
//
//  Created by YS on 4/12/19.
//  Copyright © 2019 YS. All rights reserved.
//

import ARKit

extension ViewController: ARSessionDelegate {
    /// - Tag: ARSCNViewDelegate (Action after object is scanned)
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            DispatchQueue.main.async {
                self.arLogo.isHidden = imageAnchor.isTracked
                // After image acnhor disappear, then remove anchor.
                if imageAnchor.isTracked == false {
                    self.session.remove(anchor: imageAnchor)
                    clearCache()
                }
            }
        } else if anchor is ARObjectAnchor {
            DispatchQueue.main.async {
                self.arLogo.isHidden = true
            }
        }
    }
}

