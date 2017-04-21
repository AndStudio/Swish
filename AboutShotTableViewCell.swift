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
        
    }
    
    
    //MARK: - Helpers
    
    func updateViews() {
        guard let shot = shot, let user = shot.user else { return }
        
        self.userNameLabel.text = "by \(user.userName) | \(user.userUserName)"
        self.likeCountLabel.text = "\(shot.likeCount)"
        self.viewCountLabel.text = "\(shot.viewCount)"
        
        if user.userAvatar != nil {
            self.userAvatarImageView.image = user.userAvatar
        } else {
            
            ImageController.image(forURL: user.userAvatarURL) { (image) in
                DispatchQueue.main.async {
                    self.userAvatarImageView.image = image
                }
            }
        }
     
        // set stuff 
        
        shareButton.backgroundColor = Colors.primaryPink
        
        viewCountLabel.textColor = Colors.dribbbleDarkGray
        likeCountLabel.textColor = Colors.dribbbleDarkGray
        userNameLabel.textColor = Colors.dribbbleDarkGray
        
        userNameLabel.text = ""
        viewCountLabel.text = ""
        likeCountLabel.text = ""
        
        //make the userAvatarImage round
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.size.width/2
        userAvatarImageView.clipsToBounds = true
        
        //round the share button corners
        shareButton.layer.cornerRadius = 5
        shareButton.clipsToBounds = true
        
    }
}
