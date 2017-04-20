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
    
    @IBOutlet weak var titleLabelOutlet: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    //MARK: - Properties

    
    //MARK: - UI Actions
    // FIXME: No action in here, do we need this?
    @IBAction func signInButtonTapped(_ sender: Any) {

    }
    
    //MARK: - View lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Keychain.value(forKey: "accessToken") != nil {
            UserController.fetchAuthenticatedUser(completion: { (authenticatedUser) in
                
                DispatchQueue.main.async {
                    guard let authenticatedUser = authenticatedUser else { /*FIXME: Add error alert controller */ return }
                    DribbleApi.currentUser = authenticatedUser
                    
                    self.performSegue(withIdentifier: "toSwipeVC", sender: self)
                }
            })
        }
    } 
    
    //MARK: - Helpers
    
    func updateViews() {
        
        // set up button and title label 
        titleLabelOutlet.text = "testing this "
        
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
