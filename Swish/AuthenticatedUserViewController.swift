//
//  AuthenticatedUserViewController.swift
//  Swish
//
//  Created by Work on 4/19/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class AuthenticatedUserViewController: UIViewController {
    
    // MARK: Properties
    var user: User? = DribbleApi.currentUser
    
    // MARK: IBOutlets
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.user = DribbleApi.currentUser
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func updateViews() {
        guard let user = user else { return }
        usernameLabel.text = user.userUserName
        ImageController.image(forURL: (user.userAvatarURL)) { (image) in
            self.userAvatarImageView.image = image
        }
    }
    
    // MARK: IBActions
    @IBAction func logOutButtonTapped(_ sender: Any) {
        _ = Keychain.removeValue(forKey: "accessToken")
        performSegue(withIdentifier: "toMainVC", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserVC" {
            guard
                let destinationVC = segue.destination as? UserDetailViewController,
                let user = user
            else { return }
            
            destinationVC.user = user
        }
    }

}
