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
    var user: User? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userUserNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.user = DribbleApi.currentUser
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.size.width/2
        userAvatarImageView.clipsToBounds = true
    }

    func updateViews() {
        guard let user = user else { return }
        usernameLabel.text = user.userName
        userUserNameLabel.text = user.userUserName
        ImageController.image(forURL: (user.userAvatarURL)) { (image) in
            self.userAvatarImageView.image = image
        }
    }
    
    // MARK: IBActions
    @IBAction func logOutButtonTapped(_ sender: Any) {
        _ = Keychain.removeValue(forKey: "accessToken")
        performSegue(withIdentifier: "toMainVC", sender: self)
    }
    
    @IBAction func dismissViewButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserVC" {
            guard
                let destinationVC = segue.destination as? UserCollectionViewController,
                let user = user
            else { return }
            
            destinationVC.user = user
        }
    }

}
