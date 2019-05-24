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
        
        setConstraintsNameLabel()
        setConstraintsTextView()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            setConstraintsShowVideoButton()
            setConstraintsShowCaseButton()
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            showVideoButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint(item: showVideoButton,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: closeButton,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: -100).isActive = true
            
            NSLayoutConstraint(item: showVideoButton,
                               attribute: .rightMargin,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: -30).isActive = true
            
            showCaseButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint(item: showCaseButton,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: closeButton,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: -100).isActive = true
            
            NSLayoutConstraint(item: showCaseButton,
                               attribute: .leftMargin,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 30).isActive = true
        }
        
        
        setConstraintsCloseButton()
    }
    

    func addSubviews() {
        self.view.addSubview(nameLabel)
        self.view.addSubview(textView)
        self.view.addSubview(closeButton)
        self.view.addSubview(showVideoButton)
        self.view.addSubview(showCaseButton)
    }
    
    func initViews() {
        if objectName == "anatomyBuilding" {
            nameLabel.text = "医学之美"
            textView.text = "送给临近毕业的你，愿同学们前程似锦～"
            showCaseButton.isHidden = true
        } else {
            if objectName == "Heart" {
                nameLabel.text = "心脏"
            } else {
                nameLabel.text = objectName
            }
            textView.text = ObjectInfo.getText(for: objectName)
            showCaseButton.isHidden = false
        }
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 58)
        nameLabel.textColor = UIColor.black
        
        
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = UIColor.gray
        textView.isEditable = false

        closeButton.setImage(UIImage(named: "scanButton"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        showVideoButton.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        showVideoButton.setTitle("视频", for: .normal)
        showVideoButton.setTitleColor(UIColor.darkGray, for: .normal)
        showVideoButton.addTarget(self, action: #selector(openVideo), for: .touchUpInside)
        
        showCaseButton.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        showCaseButton.setTitle("病例", for: .normal)
        showCaseButton.setTitleColor(UIColor.darkGray, for: .normal)
        showCaseButton.addTarget(self, action: #selector(openCase), for: .touchUpInside)
    }
    
    // MARK: - Methods for buttons
    
    @objc func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func openVideo() {
        var name = "Null"
        
        if objectName == "anatomyBuilding" {
            name = objectName
        } else if objectName == "Heart" {
            name = "hospitalSimulatorVideo"
        } else {
            name = "Hand-Anatomy"
        }
        
        guard let path = Bundle.main.path(forResource: name, ofType:"mp4") else {
            debugPrint("\(name).mp4 not found")
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
        
        if objectName == "Heart" {
            caseVC.fileName = "heartCase"
        } else {
            caseVC.fileName = "case"
        }
        
        self.present(caseVC, animated: true, completion: nil)
        AudioServicesPlaySystemSound(SystemSoundID(1519))
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
    
    func setConstraintsTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let margins = view.layoutMarginsGuide
        
        textView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 20).isActive = true
        
        textView.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -20).isActive = true
        
        textView.topAnchor.constraint(equalTo: nameLabel.layoutMarginsGuide.bottomAnchor, constant: 20).isActive = true
        
        textView.bottomAnchor.constraint(equalTo: showVideoButton.layoutMarginsGuide.topAnchor, constant: -30).isActive = true
    }
    
    func setConstraintsShowVideoButton() {
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
    }
    
    func setConstraintsShowCaseButton() {
        showCaseButton.translatesAutoresizingMaskIntoConstraints = false
        
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
