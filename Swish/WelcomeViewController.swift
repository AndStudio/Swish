//
//  WelcomeViewController.swift
//  Swish
//
//  Created by Clay Mills on 4/26/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabelOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func updateViews() {
        
//        set up button and title label
        logoImageView.image = UIImage(named: "swish2")
        titleLabelOutlet.textColor = Colors.dribbbleDarkGray
        titleLabelOutlet.text = "Tinder for Dribbble"
        titleLabelOutlet.font = UIFont(name: "ArialRounded", size: 18)
        self.view.backgroundColor = Colors.dribbbleGray
    }
    
}
