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
    
    @IBOutlet weak var logoImageView: UIImageView!
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
        
        navigationController?.navigationBar.isHidden = true
        
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
        
        logoImageView.image = UIImage(named: "swish2")
        
        self.view.backgroundColor = Colors.dribbbleGray
        titleLabelOutlet.textColor = Colors.dribbbleDarkGray
        titleLabelOutlet.text = "Tinder for Dribbble"
        titleLabelOutlet.font = UIFont(name: "ArialRounded", size: 18)
        
        signInButton.backgroundColor = Colors.primaryPink
        signInButton.setTitle("Sign in", for: .normal)
        signInButton.tintColor = .white
        signInButton.layer.cornerRadius = 5
        signInButton.clipsToBounds = true
        
    }
    
}
