//
//  MoreInfoViewController.swift
//  Swish
//
//  Created by Clay Mills on 4/26/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController {
    @IBOutlet weak var seeProfileLabel: UILabel!
    @IBOutlet weak var seeLikesLabel: UILabel!
    @IBOutlet weak var seeMoreLabel: UILabel!

    @IBOutlet weak var mainImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func updateViews() {
        
        //        set up button and title label
        seeProfileLabel.textColor = Colors.dribbbleDarkGray
        seeProfileLabel.text = "See profile"
        seeProfileLabel.font = UIFont(name: "ArialRounded", size: 18)
        
        seeLikesLabel.textColor = Colors.dribbbleDarkGray
        seeLikesLabel.text = "See likes"
        seeLikesLabel.font = UIFont(name: "ArialRounded", size: 18)
        
        seeMoreLabel.textColor = Colors.dribbbleDarkGray
        seeMoreLabel.text = "Click to see more by designer"
        seeMoreLabel.font = UIFont(name: "ArialRounded", size: 18)
        
        mainImageView.image = UIImage(named: "mainImage")
        
        self.view.backgroundColor = Colors.dribbbleGray

    }
}
