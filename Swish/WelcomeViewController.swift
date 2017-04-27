//
//  WelcomeViewController.swift
//  Swish
//
//  Created by Clay Mills on 4/26/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeToLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.isHidden = true
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func updateViews() {
        
        welcomeToLabel.textColor = Colors.dribbbleDarkGray
        welcomeToLabel.text = "Like dribbble shots by swishing through them. 😍"
        welcomeToLabel.font = UIFont(name: "ArialRounded", size: 18)
        
        logoImageView.image = UIImage(named: "cardsIllustration")
        
        self.view.backgroundColor = .white
    }
    
}
