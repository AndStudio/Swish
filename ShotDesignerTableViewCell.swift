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
    
    //MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    //MARK: - Helpers
    
    func updateViews() {
        
    }
}
