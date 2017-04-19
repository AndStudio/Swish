//
//  UserDetailViewController.swift
//  Swish
//
//  Created by Clay Mills on 4/12/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var maxPage: Int = 1
    var page: Int = 1
    var userAvatar = UIImage()
    var shots: [Shot] = []
    var shotRefreshDelegate: ShotRefreshDelegate?
    var user: User? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        guard let user = user else { return }
        ApiController.fetchShots(forUser: user, page: String(page)) { (shots) in
            self.shots = shots
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userShotCell", for: indexPath) as? ShotCollectionViewCell else { return ShotCollectionViewCell() }
        
        cell.shot = shots[indexPath.row]
        return cell
    }
    
    func updateViews() {
        guard let user = user else {return}
        userNameLabel.text = user.userUserName
        nameLabel.text = user.userName
        ImageController.image(forURL: (user.userAvatarURL)) { (image) in
            DispatchQueue.main.async {
                self.userAvatarImageView.image = image
            }
        }
    }
    
    // Pagination
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let user = self.user else { return }
        let doubleCount = Double(user.shotsCount)
        self.maxPage = Int(ceil(doubleCount / 20.0))
        
        if indexPath.row == (self.shots.count - 5) && self.page <= maxPage {
            self.page += 1
            guard let user = self.user else { return }
            ApiController.fetchShots(forUser: user, page: String(page), completion: { (shots) in
                
                let oldShotsEndIndex = self.shots.endIndex
                self.shots.append(contentsOf: shots)
                DispatchQueue.main.async {
                    if self.page < self.maxPage {
                        let newShotsEndIndex = self.shots.endIndex - 1
                        let newShotsIndexPaths = (oldShotsEndIndex...newShotsEndIndex).map({IndexPath(item: $0, section: 0)})
                        
                        self.collectionView.insertItems(at: newShotsIndexPaths)
                    }
                }
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ShotCollectionViewCell, let selectedShot = cell.shot else { return }
        self.shotRefreshDelegate?.reloadShotDetailVCWith(selectedShot: selectedShot)
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            //destination
      //  if segue.identifier == "shotDetailView" {
            //what 
        //    guard let indexPath = collectionView.indexPath(for: userShotCell),
            //where
          //  let destinationVC = segue.destination as? ShotDetailViewController else { return }
            // what to the where
            //let userShotCell = shots.description
            //destinationVC.reloadShotDetailVC = userShotCell
        //}

    //}
}


protocol ShotRefreshDelegate: class {
    
    func reloadShotDetailVCWith(selectedShot: Shot)
}


