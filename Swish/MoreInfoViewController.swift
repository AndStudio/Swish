//
//  MoreInfoViewController.swift
//  Swish
//
//  Created by Clay Mills on 4/26/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var illustrationImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func updateViews() {
        
        
        descriptionLabel.text = "See more work from the designers you love."
        descriptionLabel.font = UIFont(name: "ArialRounded", size: 18)
        descriptionLabel.textColor = Colors.dribbbleDarkGray
        
        illustrationImageView.image = UIImage(named: "userIllustration")
        
        self.view.backgroundColor = .white

    }
}
