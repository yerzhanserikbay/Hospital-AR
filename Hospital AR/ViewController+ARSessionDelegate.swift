//
//  ViewController+ARSessionDelegate.swift
//  Hospital AR
//
//  Created by YS on 4/12/19.
//  Copyright © 2019 YS. All rights reserved.
//

import ARKit

extension ViewController: ARSessionDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            DispatchQueue.main.async {
                self.arLogo.isHidden = imageAnchor.isTracked
            }
        }
    }
}
