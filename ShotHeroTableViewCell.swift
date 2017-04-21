//
//  ShotHeroTableViewCell.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/21/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class ShotHeroTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var shot: Shot? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Outlets 
    @IBOutlet weak var shotImageView: UIImageView!
    @IBOutlet weak var heroTopConstraint: NSLayoutConstraint!
    
    
    //MARK: - Actions


    //MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Colors.backgroundGray
    }
    
    
    //MARK: - Helpers 
    
    func updateViews() {
        guard let shot = shot else { return }
        
        if shot.largeImage != nil {
            self.shotImageView.image = shot.largeImage
        } else {
            if shot.hiDpiImageURL == nil {
                ImageController.image(forURL: shot.normalImageURL, completion: { (image) in
                    DispatchQueue.main.async {
                        self.shotImageView.image = image
                    }
                })
            } else {
                guard let hiDpiImageURL = shot.hiDpiImageURL else { return }
                ImageController.image(forURL: hiDpiImageURL, completion: { (image) in
                    DispatchQueue.main.async {
                        self.shotImageView.image = image
                    }
                })
            }
        }
    }
}
