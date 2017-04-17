//
//  UserProfileCollectionReusableView.swift
//  Swish
//
//  Created by Clay Mills on 4/17/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class UserProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
        
    @IBOutlet weak var nameLabel: UILabel!
    
    var users: User? {
        didSet {
            updateViews()
        }
    }
    func updateViews() {
        guard let user = users else {return}
        userNameLabel.text = user.userUserName
        nameLabel.text = user.userName
        ImageController.image(forURL: (user.userURL)) { (image) in
            self.userAvatarImageView.image = image
        }
    }
}
