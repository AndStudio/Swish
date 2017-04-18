//
//  LikedShotCollectionViewCell.swift
//  Swish
//
//  Created by Work on 4/12/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class LikedShotCollectionViewCell: UICollectionViewCell {
    
    let apiController = ApiController()
    
    // MARK: IBOutlets
    @IBOutlet weak var shotTeaserImageView: UIImageView!
    @IBOutlet weak var shotTitleLabel: UILabel!
    
    // MARK: Properties
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
