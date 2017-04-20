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
    
    var shot: Shot? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        
        guard let shot = shot,
            let shotImage = shot.largeImage else { return }
        
        let imageView = UIImageView(image: shotImage)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 0.8)
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        imageView.frame = CGRect(x: 12, y: 12, width: self.frame.width - 24, height: self.frame.height - 103)
        self.addSubview(imageView)
        
        // text labels
        
        // title
        let title = shot.title
        guard let username = shot.user?.userName else { return }
        
        let titleLabel = UILabel()
        titleLabel.text = "\(title)"
        titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        titleLabel.textColor = Colors.dribbbleDarkGray
        titleLabel.textAlignment = .left
        titleLabel.frame = CGRect(x: 16, y: imageView.frame.maxY + 18, width: 300, height: 28)
        self.addSubview(titleLabel)
        
        let usernameLabel = UILabel()
        usernameLabel.text = "by "+"\(username)"
        usernameLabel.font = UIFont(name: "AvenirHeavy", size: 14)
        usernameLabel.textColor = Colors.highlightBlue
        usernameLabel.textAlignment = .left
        usernameLabel.frame = CGRect(x: 16, y: titleLabel.frame.maxY + 4, width: 300, height: 24)
        self.addSubview(usernameLabel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
