//
//  ShotDescriptionTableViewCell.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/21/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class ShotDescriptionTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    var shot: Shot? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var shotDescriptionTextView: UITextView!
    
    //MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Colors.backgroundGray
        
    }
    
    
    //MARK: - Helpers
    
    func updateViews() {
        guard let shot = shot else { return }
        let description = shot.description ?? ""
        
        shotDescriptionTextView.text = description
        
        shotDescriptionTextView.textColor = UIColor.lightGray
        
        shotDescriptionTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 15)
        
    }
}
