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
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var shotCountBackground: UIView!
    @IBOutlet weak var shotCountLabel: UILabel!
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
        userNameLabel.textColor = Colors.primaryPink
        userNameLabel.font = UIFont(name: "ArialRoundedMTBold", size: 28)
        
        shotCountBackground.backgroundColor = .white
        shotCountBackground.layer.cornerRadius = 4
        
        shotCountLabel.text = "\(user.shotsCount)"
        shotCountLabel.textColor = Colors.dribbbleDarkGray
        shotCountLabel.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        
        aboutTextView.text = user.bio
        aboutTextView.textColor = Colors.paraGray
        aboutTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        aboutTextView.isScrollEnabled = false
        
        headerCellBottomSep.backgroundColor = Colors.auxLightGray
        
        shotCountBackground.layer.masksToBounds = false
        shotCountBackground.layer.shadowOffset = CGSize(width: 0, height: 1)
        shotCountBackground.layer.shadowRadius = 1
        shotCountBackground.layer.shadowOpacity = 0.08
        
    }
}
