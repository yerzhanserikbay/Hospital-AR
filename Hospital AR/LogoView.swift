//
//  StartLogoView.swift
//  Hospital AR
//
//  Created by YS on 4/15/19.
//  Copyright © 2019 YS. All rights reserved.
//

import UIKit

class LogoView: UIVisualEffectView {
    
    let logoImage = UIImageView()
    let label = UILabel()
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        self.effect = UIBlurEffect(style: .dark)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 30
        
        logoImage.image = UIImage(named: "arLogo")
        self.contentView.addSubview(logoImage)
        
        label.text = "Find an image"
        label.font = UIFont.systemFont(ofSize: 21)
        label.textColor = .white
        label.sizeToFit()
        
        self.contentView.addSubview(label)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 173).isActive = true
        self.heightAnchor.constraint(equalToConstant: 173).isActive = true
        
        let margins = self.layoutMarginsGuide
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        logoImage.topAnchor.constraint(equalTo: margins.topAnchor, constant: 15).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant: 91).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 91).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -15).isActive = true
        label.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

