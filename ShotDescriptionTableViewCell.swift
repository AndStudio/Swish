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
        
    }
    
    
    //MARK: - Helpers
    
    func updateViews() {
        guard let shot = shot else { return }
        let description = shot.description ?? ""
        self.shotDescriptionTextView.text = description
        
        shotDescriptionTextView.textColor = Colors.dribbbleDarkGray
        shotDescriptionTextView.text = ""
        
    }
}
