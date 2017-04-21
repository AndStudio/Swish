//
//  ShotDetailTitleTableViewCell.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/21/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class ShotDetailTitleTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var shot: Shot? {
        didSet {
            updateViews()
        }
    }
    
    var user: User?
    
    //MARK: - Outlets 
    
    @IBOutlet weak var shotTitleLabel: UILabel!
    
    //MARK: - View lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Colors.backgroundGray
    }
    
    
    //MARK: - Helpers
    
    func updateViews() {
        shotTitleLabel.text = shot?.title
        shotTitleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 30)
    }
    

}
