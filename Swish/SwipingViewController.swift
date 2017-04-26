//
//  SwipingViewController.swift
//  Swish
//
//  Created by Clay Mills on 4/26/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class SwipingViewController: UIViewController {
    
    @IBOutlet weak var swipeRightLabel: UILabel!
    @IBOutlet weak var swipeRightImageView: UIImageView!

    @IBOutlet weak var swipeLeftLabel: UILabel!
    @IBOutlet weak var swipeLeftImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func updateViews() {
        
        //        set up button and title label
        swipeRightLabel.textColor = Colors.dribbbleDarkGray
        swipeRightLabel.text = "Swipe right or tap heart to like"
        swipeRightLabel.font = UIFont(name: "ArialRounded", size: 18)
        swipeRightImageView.image = UIImage(named: "likeImage")
        
        swipeLeftLabel.textColor = Colors.dribbbleDarkGray
        swipeLeftLabel.text = "Swipe left or tap X to ignore"
        swipeLeftLabel.font = UIFont(name: "ArialRounded", size: 18)
        swipeLeftImageView.image = UIImage(named: "dislikeImage")
        
        self.view.backgroundColor = Colors.dribbbleGray
    }
}
