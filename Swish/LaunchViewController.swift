//
//  LaunchViewController.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/10/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    //MARK: - Outlets 
    
    
    //MARK: - Properties
    
    @IBOutlet weak var titleLabelOutlet: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    
    //MARK: - UI Actions 
    
    @IBAction func signInButtonTapped(_ sender: Any) {
    }
    
    //MARK: - View lifecyle
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //MARK: - Helpers
    
    func updateViews() {
        
        // set up button and title label 
        
        self.view.backgroundColor = Colors.primaryPink
        titleLabelOutlet.textColor = Colors.secondaryPink
        titleLabelOutlet.text = "Swish"
        signInButton.backgroundColor = .white
        signInButton.setTitle("Sign in", for: .normal)
        signInButton.tintColor = Colors.secondaryPink
        signInButton.layer.cornerRadius = 3
        signInButton.clipsToBounds = true
        
    }
}
