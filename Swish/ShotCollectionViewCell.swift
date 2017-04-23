//
//  LikedShotCollectionViewCell.swift
//  Swish
//
//  Created by Work on 4/12/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class ShotCollectionViewCell: UICollectionViewCell {
    
    let apiController = ApiController()
    
    // MARK: IBOutlets
    @IBOutlet weak var shotTeaserImageView: UIImageView!
    @IBOutlet weak var shotTitleLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    
    // MARK: Properties
    var shot: Shot? {
        didSet {
            DispatchQueue.main.async {
                guard let shot = self.shot else { return }
                self.apiController.fetchTeaserImage(forShot: shot, completion: { (teaserImage) in
                    self.updateViews()
                })
            }
        }
    }
    
    func updateViews() {
        guard let shot = shot else { return }
        shotTeaserImageView.image = shot.teaserImage
        shotTitleLabel.text = shot.title
        shotTitleLabel.textColor = Colors.highlightBlue
        
        cellBackgroundView.layer.cornerRadius = 4
        cellBackgroundView.clipsToBounds = true
    }
}
