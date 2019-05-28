//
//  BiodigitalViewController.swift
//  Hospital AR
//
//  Created by YS on 5/27/19.
//  Copyright © 2019 YS. All rights reserved.
//

import UIKit
import HumanKit

class BiodigitalViewController: UIViewController, HumanBodyDelegate {
    
    var objectName = String()
    
    let nameLabel = UILabel()
    
    let closeButton = UIButton()
    
    var body: HumanBody!
    
    var delegate: ActionAfterCloseViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    
        initViews()
        addSubviews()
        setConstraintsNameLabel()
        setConstraintsCloseButton()
        
        body.load(model: ObjectInfo.getID(for: objectName)) {}
    }
    
    func addSubviews() {
        self.view.addSubview(nameLabel)
        self.view.addSubview(closeButton)
    }
    
    func initViews() {
        body = HumanBody(view: self.view)
        
        body.delegate = self
        
        if objectName == "spine-bone" {
            nameLabel.text = "颈椎椎体置换"
        }
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 58)
        nameLabel.textColor = UIColor.black
        nameLabel.adjustsFontSizeToFitWidth = true
    
        closeButton.setImage(UIImage(named: "scanButton"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    }
    
    // MARK: - Methods for buttons
    
    @objc func closeView() {
        delegate?.closeViewController()
        self.dismiss(animated: true, completion: nil)
    }

    
    func setConstraintsNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: nameLabel,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 60).isActive = true
        
        NSLayoutConstraint(item: nameLabel,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: nameLabel,
                           attribute: .left,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .leftMargin,
                           multiplier: 1.0,
                           constant: 20).isActive = true
        
        NSLayoutConstraint(item: nameLabel,
                           attribute: .right,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .rightMargin,
                           multiplier: 1.0,
                           constant: -20).isActive = true
        
        NSLayoutConstraint(item: nameLabel,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 80).isActive = true
    }
    
    func setConstraintsCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: closeButton,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .bottomMargin,
                           multiplier: 1.0,
                           constant: 10).isActive = true
        
        NSLayoutConstraint(item: closeButton,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: closeButton,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 124).isActive = true
        
        NSLayoutConstraint(item: closeButton,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 124).isActive = true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
