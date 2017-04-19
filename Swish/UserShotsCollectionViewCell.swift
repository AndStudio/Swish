//
//  UserShotsCollectionViewCell.swift
//  Swish
//
//  Created by Clay Mills on 4/18/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class UserShotsCollectionViewCell: UICollectionViewCell {
    
    let apiController = ApiController()
    
    @IBOutlet weak var shotTeaserImageView: UIImageView!

    @IBOutlet weak var shotTitleLabel: UILabel!
    
    var shot: Shot? {
        didSet {
            DispatchQueue.main.async {
                guard let shot = self.shot else { return }
                self.apiController.fetchTeaserImage(forShot: shot, completion: { (teaserImage) in
                    self.shotTeaserImageView.image = teaserImage
                })
                self.updateViews()
            }
        }
    }
    
    
    func updateViews() {
        shotTeaserImageView.image = shot?.teaserImage
        shotTitleLabel.text = shot?.title
    }

}
