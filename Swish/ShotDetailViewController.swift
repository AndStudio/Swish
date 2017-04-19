//
//  ShotDetailViewController.swift
//  Swish
//
//  Created by Taylor Phillips on 4/13/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class ShotDetailViewController: UITableViewController, ShotRefreshDelegate {
    
    
    //MARK: - outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var shotDescriptionTextView: UITextView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var shotImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    
    @IBOutlet weak var descriptionTableViewCell: UITableViewCell!
    @IBOutlet weak var userTableViewCell: UITableViewCell!
    
    //MARK: - actions
    
    @IBAction func ShareButtonTapped(_ sender: Any) {
        guard let shot = self.shotImageView.image else { return }
        let activiityViewController = UIActivityViewController(activityItems: [shot], applicationActivities: nil)
        present(activiityViewController, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userButtonTapped(_ sender: Any) {
        
        let userStoryboard = UIStoryboard(name: "User", bundle: nil)
        guard let userDetailVC = userStoryboard.instantiateViewController(withIdentifier: "userDetailVC") as? UserDetailViewController else { return }
        userDetailVC.shotRefreshDelegate = self
        self.present(userDetailVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        views()
    }

    var shot: Shot? {
        didSet {
            DispatchQueue.main.async {
                guard self.isViewLoaded else { return }
                self.updateViews()
            }
        }
    }
    
    func reloadShotDetailVCWith(selectedShot: Shot) {
        self.shot = selectedShot
    }
    
    func updateViews() {
        
        guard let shot = shot, let user = shot.user else { return }
        let description = shot.description ?? ""
        self.shotDescriptionTextView.text = description
        self.userNameLabel.text = "by \(user.userName) | \(user.userUserName)"
        self.titleLabel.text = shot.title
        self.likeCountLabel.text = "\(shot.likeCount)"
        self.viewCountLabel.text = "\(shot.viewCount)"
        self.creationDateLabel.text = shot.createdDate
        
        if shot.largeImage != nil {
            self.shotImageView.image = shot.largeImage
        } else {
            if shot.hiDpiImageURL == nil {
                ImageController.image(forURL: shot.normalImageURL, completion: { (image) in
                    self.shotImageView.image = image
                })
            } else {
                guard let hiDpiImageURL = shot.hiDpiImageURL else { return }
                ImageController.image(forURL: hiDpiImageURL, completion: { (image) in
                    DispatchQueue.main.async {
                        self.shotImageView.image = image
                    }
                })
            }
        }
        
        if user.userAvatar != nil {
            self.userAvatarImageView.image = user.userAvatar
        } else {
            
            ImageController.image(forURL: user.userAvatarURL) { (image) in
                self.userAvatarImageView.image = image
            }
        }
    }
    
    func views() {
        
        guard let shot = shot else { return }
        shotImageView.image = shot.teaserImage
        
        shareButton.backgroundColor = Colors.primaryPink
        shareButton.setTitleColor(.white, for: .normal)
        shotDescriptionTextView.textColor = Colors.dribbbleDarkGray
        creationDateLabel.textColor = Colors.dribbbleDarkGray
        viewLabel.textColor = Colors.dribbbleDarkGray
        viewCountLabel.textColor = Colors.dribbbleDarkGray
        likeLabel.textColor = Colors.dribbbleDarkGray
        likeCountLabel.textColor = Colors.dribbbleDarkGray
        userNameLabel.textColor = Colors.dribbbleDarkGray
        shotDescriptionTextView.text = ""
        creationDateLabel.text = ""
        titleLabel.text = ""
        userNameLabel.text = ""
        viewCountLabel.text = ""
        likeCountLabel.text = ""
        creationDateLabel.text = ""
        
        //make the userAvatarImage round
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.size.width/2
        userAvatarImageView.clipsToBounds = true
        
        //round the share button corners
        shareButton.layer.cornerRadius = 5
        shareButton.clipsToBounds = true
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight : CGFloat = 0
        if indexPath.row == 0 {
            tableView.rowHeight = self.view.frame.height / 2.5
            tableView.estimatedRowHeight = 281
            rowHeight = tableView.rowHeight
        }
        if indexPath.row == 1 {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 281
            rowHeight = tableView.rowHeight
        }
        if indexPath.row == 2 {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 281
            rowHeight = tableView.rowHeight

        }

        if indexPath.row == 3 {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 281
            rowHeight = tableView.rowHeight
        }
        return rowHeight
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserDVC" {
            
            guard let destinationVC = segue.destination as? UserDetailViewController else { return }
            let userData = shot?.user
            destinationVC.user = userData
            
        }
    }
}
