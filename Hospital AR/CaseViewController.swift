//
//  CaseViewController.swift
//  Hospital AR
//
//  Created by YS on 4/16/19.
//  Copyright © 2019 YS. All rights reserved.
//

import UIKit
import WebKit

class CaseViewController: UIViewController, WKNavigationDelegate {
    
    let webView = WKWebView(frame: UIScreen.main.bounds)
    
    let closeButton = UIButton.interfaceButton()
    
    var fileName = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        webView.navigationDelegate = self
        
        closeButton.setTitle("Done", for: .normal)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        closeButton.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.view.addSubview(closeButton)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        closeButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        closeButton.rightAnchor.constraint(equalTo: self.view.layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
        
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        guard let path = Bundle.main.path(forResource: fileName, ofType:"pdf") else {
            debugPrint("\(fileName).pdf not found")
            return
        }
        
        webView.load(URLRequest(url: URL(fileURLWithPath: path)))

        // Do any additional setup after loading the view.
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
