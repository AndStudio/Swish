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
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var shotDescriptionTextView: UITextView!
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var tagsTextView: UITextView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var shotImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    //MARK: - actions
    @IBAction func ShareButtonTapped(_ sender: Any) {
        
        guard let shot = self.shotImageView.image else { return }
        
        let activiityViewController = UIActivityViewController(activityItems: [shot], applicationActivities: nil)
        
        present(activiityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        ApiController.loadShots { (shots) in
            guard let shot = shots.first else { return }
            self.shot = shot
        }
        
        views()
        
    }
    
    
    var shot: Shot? {
        didSet {
            updateViews()
            
        }
    }
    
    func updateViews() {
        
        
//        var userUserName: String
        guard let shot = shot else { return }
        guard let user = shot.user else { return }
        self.shotDescriptionTextView.text = shot.description
       
        self.userNameLabel.text = "\(user.userName) | \(user.userUserName)"
        self.userAvatarImageView.image = shot.user?.userAvatar
        self.tagsTextView.text = "\(shot.tags)"
        self.likeCountLabel.text = "\(shot.likeCount)"
        self.viewCountLabel.text = "\(shot.viewCount)"
        self.creationDateLabel.text = shot.createdDate

        if shot.hiDpiImageURL == nil {
            ImageController.image(forURL: shot.normalImageURL, completion: { (image) in
                self.shotImageView.image = image
            })
        } else {
            guard let hiDpiImageURL = shot.hiDpiImageURL else { return }
            ImageController.image(forURL: hiDpiImageURL, completion: { (image) in
                self.shotImageView.image = image
            })
        }
        ImageController.image(forURL: user.userAvatarURL) { (image) in
            self.userAvatarImageView.image = image
        }
    }
    
    func views() {
        shareButton.backgroundColor = Colors.primaryPink
        shareButton.setTitleColor(.white, for: .normal)
        tagsTextView.textColor = Colors.dribbbleDarkGray
        shotDescriptionTextView.textColor = Colors.dribbbleDarkGray
        creationDateLabel.textColor = Colors.dribbbleDarkGray
        viewLabel.textColor = Colors.dribbbleDarkGray
        viewCountLabel.textColor = Colors.dribbbleDarkGray
        likeLabel.textColor = Colors.dribbbleDarkGray
        likeCountLabel.textColor = Colors.dribbbleDarkGray
        tagsLabel.textColor = Colors.dribbbleDarkGray
        
        
        //make the userAvatarImage round
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.size.width/2
        userAvatarImageView.clipsToBounds = true
        
    }
    
}
