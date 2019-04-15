//
//  InfoViewController.swift
//  Hospital AR
//
//  Created by YS on 4/15/19.
//  Copyright © 2019 YS. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    var objectName = String()
    
    let nameLabel = UILabel()
    
    let textView = UITextView()
    
    let closeButton = UIButton()
    
    
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
    }
    
    func initViews() {
        nameLabel.text = objectName
        nameLabel.font = UIFont.boldSystemFont(ofSize: 58)
        nameLabel.textColor = UIColor.black
        
        textView.text = ObjectInfo.getText(for: objectName)
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = UIColor.gray
        textView.isEditable = false

        closeButton.frame = CGRect(x: 0, y: 0, width: 104, height: 104)
        closeButton.setImage(UIImage(named: "scanButton"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    }
    
    func setConstraints() {
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: nameLabel,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 80).isActive = true
        
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

        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let margins = view.layoutMarginsGuide
        
        textView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = true
        
        textView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20).isActive = true
        
        textView.topAnchor.constraint(equalTo: nameLabel.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        
        textView.bottomAnchor.constraint(equalTo: closeButton.layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: closeButton,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .bottomMargin,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: closeButton,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        
    }
    
    @objc func closeView() {
        self.dismiss(animated: true, completion: nil)
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
