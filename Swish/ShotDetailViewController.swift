//
//  ShotDetailViewController.swift
//  Swish
//
//  Created by Taylor Phillips on 4/13/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class ShotDetailViewController: UIViewController {

    //MARK: - outlets
    @IBOutlet weak var shotDescriptionTextView: UITextView!
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var tagsTextView: UITextView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var shotImageView: UIImageView!
    
    //MARK: - actions
    @IBAction func ShareButtonTapped(_ sender: Any) {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiController.loadShots { (shots) in
            guard let shot = shots.first else { return }
            self.shot = shot
        }
        updateViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var shot: Shot?
    
    func updateViews() {
        var userUserName: String
        guard let shot = shot , let user = shot.user else { return }
        self.shotDescriptionTextView.text = shot.description
        if shot.user?.userUserName == nil {
            userUserName = ""
        }  else {
            userUserName = "| \(user.userUserName)"
        }
        self.userNameButton.titleLabel?.text = "\(user.userName) \(userUserName)"
//        self.userAvatarImageView.image = shot.user.userAvatar
        self.tagsTextView.text = "\(shot.tags)"
        self.likeCountLabel.text = "\(shot.likeCount)"
        self.viewCountLabel.text = "\(shot.viewCount)"
        self.shotImageView.image = shot.largeImage
    }

}
