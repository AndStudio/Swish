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
    @IBAction func signInButtonTapped(_ sender: Any) {}
    
    //MARK: - View lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(callRateLimitAlertController), name: presentAPIAlertControllerNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(callBadCredentialsAlertController), name: presentBadCredentialsAlertControllerNotification, object: nil)
        
        navigationController?.navigationBar.isHidden = true
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    // MARK: Observer Functions
    func callRateLimitAlertController() {
        DribbleApi.presentAPIInfoAlertController(view: self)
    }
    
    func callBadCredentialsAlertController() {
        DribbleApi.presentBadCredantialsAlertController(view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if Keychain.value(forKey: "accessToken") != nil {
            UserController.fetchAuthenticatedUser(completion: { (authenticatedUser) in
                
                DispatchQueue.main.async {
                    guard let authenticatedUser = authenticatedUser else { return }
                    DribbleApi.currentUser = authenticatedUser
                    
                    self.performSegue(withIdentifier: "toSwipeVC", sender: self)
                }
            })
        } else if Keychain.value(forKey: "accessToken") == nil {
            self.updateViews()
        }
    }
    
    //MARK: - Helpers
    
    func updateViews() {
        
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
