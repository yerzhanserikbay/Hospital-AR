//
//  InfoViewController.swift
//  Hospital AR
//
//  Created by YS on 4/15/19.
//  Copyright © 2019 YS. All rights reserved.
//

import UIKit
import AVKit
import AudioToolbox

class InfoViewController: UIViewController {

    var objectName = String()
    
    let nameLabel = UILabel()
    
    let textView = UITextView()
    
    let closeButton = UIButton()
    
    let showVideoButton = UIButton.interfaceButton()
    
    let showCaseButton = UIButton.interfaceButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        initViews()
        addSubviews()
        setConstraints()
    }
    

    func addSubviews() {
        self.view.addSubview(nameLabel)
        self.view.addSubview(textView)
        self.view.addSubview(closeButton)
        self.view.addSubview(showVideoButton)
        self.view.addSubview(showCaseButton)
    }
    
    func initViews() {
        nameLabel.text = objectName
        nameLabel.font = UIFont.boldSystemFont(ofSize: 58)
        nameLabel.textColor = UIColor.black
        
        textView.text = ObjectInfo.getText(for: objectName)
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = UIColor.gray
        textView.isEditable = false

        closeButton.setImage(UIImage(named: "scanButton"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        showVideoButton.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        showVideoButton.setTitle("Video", for: .normal)
        showVideoButton.setTitleColor(UIColor.darkGray, for: .normal)
        showVideoButton.addTarget(self, action: #selector(openVideo), for: .touchUpInside)
        
        showCaseButton.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        showCaseButton.setTitle("Case", for: .normal)
        showCaseButton.setTitleColor(UIColor.darkGray, for: .normal)
        showCaseButton.addTarget(self, action: #selector(openCase), for: .touchUpInside)
    }
    
    // MARK: - Methods for buttons
    
    @objc func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func openVideo() {
        guard let path = Bundle.main.path(forResource: "Hand-Anatomy", ofType:"mp4") else {
            debugPrint("Hand-Anatomy.mp4 not found")
            return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true, completion: {
            player.play()
        })
        
        AudioServicesPlaySystemSound(SystemSoundID(1519))
    }
    
    @objc func openCase() {
        let caseVC = CaseViewController()
        print("123")
        self.present(caseVC, animated: true, completion: nil)
        AudioServicesPlaySystemSound(SystemSoundID(1519))
    }
    
    // Constraints
    func setConstraints() {
    
        /// nameLabel
        
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
        

        /// textView
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let margins = view.layoutMarginsGuide
        
        textView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 20).isActive = true
        
        textView.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -20).isActive = true
        
        textView.topAnchor.constraint(equalTo: nameLabel.layoutMarginsGuide.bottomAnchor, constant: 20).isActive = true
        
        textView.bottomAnchor.constraint(equalTo: showVideoButton.layoutMarginsGuide.topAnchor, constant: -30).isActive = true
        
        
        /// showVideoButton
        
        showVideoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: showVideoButton,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: closeButton,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: -100).isActive = true
        
        NSLayoutConstraint(item: showVideoButton,
                           attribute: .leftMargin,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .leftMargin,
                           multiplier: 1.0,
                           constant: 30).isActive = true
        
        
        showCaseButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        /// showCaseButton
        
        NSLayoutConstraint(item: showCaseButton,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: closeButton,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: -100).isActive = true
        
        NSLayoutConstraint(item: showCaseButton,
                           attribute: .rightMargin,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .rightMargin,
                           multiplier: 1.0,
                           constant: -30).isActive = true
        
        /// closeButton
        
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
