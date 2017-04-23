//
//  HeaderCollectionViewCell.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/23/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties 
    
    var user: User? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userBioLabel: UILabel!
    
    @IBOutlet weak var headerCellBottomSep: UIImageView!
    
    //MARK: - Helper Methods 
    
    func updateViews() {
        
        guard let user = user else { return }
        
        if user.userAvatar != nil {
            self.userAvatarImageView.image = user.userAvatar
        } else {
            
            ImageController.image(forURL: user.userAvatarURL) { (image) in
                DispatchQueue.main.async {
                    self.userAvatarImageView.image = image
                }
            }
        }
        
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.width / 2
        userAvatarImageView.clipsToBounds = true
        
        userNameLabel.text = user.userName
        userBioLabel.text = user.bio
        userBioLabel.textColor = Colors.dribbbleDarkGray
        
        headerCellBottomSep.backgroundColor = UIColor.lightGray
        
        
    }
}
