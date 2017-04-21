//
//  ShotDesignerTableViewCell.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/21/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class ShotDesignerTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    var shot: Shot? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Outlets 
    
    @IBOutlet weak var designerAvatarImageView: UIImageView!
    @IBOutlet weak var designerNameLabel: UILabel!
    @IBOutlet weak var designerBiolabel: UILabel!
    
    
    
    //MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Colors.backgroundGray
        
    }
    
    
    //MARK: - Helpers
    
    func updateViews() {
        guard let shot = shot,
            let designer = shot.user else { return }
        
        if designer.userAvatar != nil {
            designerAvatarImageView.image = designer.userAvatar
        } else {
            
            ImageController.image(forURL: designer.userAvatarURL) { (image) in
                DispatchQueue.main.async {
                    self.designerAvatarImageView.image = image
                }
            }
        }
        
        designerAvatarImageView.layer.cornerRadius = designerAvatarImageView.frame.height/2
        designerAvatarImageView.clipsToBounds = true
        
        designerNameLabel.text = designer.userName
        designerBiolabel.text = designer.bio
        
        designerNameLabel.textColor = Colors.primaryPink
        designerBiolabel.textColor = Colors.dribbbleDarkGray
        
    }
}
