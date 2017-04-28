//
//  ShotCard.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/15/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit


class ShotCard: CardView {
    
    //MARK: - Properties
    
    var imageView: UIImageView?
    var avatarImageView: UIImageView?
    var titleLabel: UILabel?
    var usernameLabel: UILabel?
    let view = UIView()
    
    override func setNeedsDisplay() {
        updateViews()
       view.reloadInputViews()

    }
    var shot: Shot? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
                self.view.reloadInputViews()
            }
        }
    }
    
    var user: User? {
        didSet {
        }
    }
    
    func updateViews() {
        
        guard let shot = shot,
            let user = shot.user,
            let shotImage = shot.largeImage,
            
            let imageView = self.imageView,
            let titleLabel = self.titleLabel,
            let usernameLabel =  self.usernameLabel else {
                return
        }
        
        imageView.image = shotImage
        
        avatarImageView?.image = user.userAvatar
        
        // text labels
        
        // title
        let title = shot.title
        
        titleLabel.text = "\(title)"
        
        guard let username = shot.user?.userName else { return }
        
        usernameLabel.text = "by "+"\(username)"

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {
        
        // shot image
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        imageView.frame = CGRect(x: 12, y: 12, width: self.frame.width - 24, height: self.frame.height - 103)
        
        self.imageView = imageView
        self.addSubview(imageView)
        
        
        //user avatar
        let avatarImageView = UIImageView()
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.backgroundColor = .white
        
        avatarImageView.frame = CGRect(x: 16, y: imageView.frame.maxY + 24, width: 45, height: 45)
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
        avatarImageView.clipsToBounds = true
        
        
        self.avatarImageView = avatarImageView
        self.addSubview(avatarImageView)
        
        
        // title label
        let titleLabel = UILabel()
        
        titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        titleLabel.textColor = Colors.dribbbleDarkGray
        titleLabel.textAlignment = .left
        titleLabel.frame = CGRect(x: 69, y: imageView.frame.maxY + 20, width: 300, height: 28)
        self.titleLabel = titleLabel
        self.addSubview(titleLabel)
        
        
        // username label
        let usernameLabel = UILabel()
        usernameLabel.font = UIFont(name: "AvenirHeavy", size: 13)
        usernameLabel.textColor = Colors.highlightBlue
        usernameLabel.textAlignment = .left
        usernameLabel.frame = CGRect(x: 69, y: titleLabel.frame.maxY, width: 300, height: 24)
        self.usernameLabel = usernameLabel
        self.addSubview(usernameLabel)
    }
}
