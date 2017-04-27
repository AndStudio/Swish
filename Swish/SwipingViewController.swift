//
//  SwipingViewController.swift
//  Swish
//
//  Created by Clay Mills on 4/26/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class SwipingViewController: UIViewController {
    
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
        
        descriptionLabel.textColor = Colors.dribbbleDarkGray
        descriptionLabel.text = "Add to your collection of liked shots."
        descriptionLabel.font = UIFont(name: "ArialRounded", size: 18)
        illustrationImageView.image = UIImage(named: "likesIllustration")

        
        self.view.backgroundColor = .white
    }
}
