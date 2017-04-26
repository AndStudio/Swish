//
//  AboutShotTableViewCell.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/21/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

protocol AboutShotCellDelegate {
    func shareButtonTapped(_ sender: AboutShotTableViewCell)
    func userButtonTapped(_ sender: AboutShotTableViewCell)
}

class AboutShotTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var delegate: AboutShotCellDelegate?
    
    var shot: Shot? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Outlets 
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    
    //MARK: - Actions 
    
    @IBAction func ShareButtonTapped(_ sender: Any) {
        delegate?.shareButtonTapped(self)
    }
    
    @IBAction func userButtonTapped(_ sender: Any) {
        delegate?.userButtonTapped(self)
    }
    
    
    //MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Colors.backgroundGray
        
    }
    
    
    //MARK: - Helpers
    
    func updateViews() {
        guard let shot = shot, let user = shot.user else { return }
        
        userNameLabel.text = "by \(user.userUserName)"
        likeCountLabel.text = "\(shot.likeCount)"
        viewCountLabel.text = "\(shot.viewCount)"
        
        if user.userAvatar != nil {
            self.userAvatarImageView.image = user.userAvatar
        } else {
            
            ImageController.image(forURL: user.userAvatarURL) { (image) in
                DispatchQueue.main.async {
                    self.userAvatarImageView.image = image
                }
            }
        }
        
        shareButton.backgroundColor = .clear
        userNameLabel.font = UIFont(name: "ArialRoundedMTBold", size: 18)
        viewCountLabel.textColor = Colors.dribbbleDarkGray
        likeCountLabel.textColor = Colors.dribbbleDarkGray
        userNameLabel.textColor = Colors.primaryPink
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.size.width/2
        userAvatarImageView.clipsToBounds = true

        
    }
}
