//
//  UserDetailViewController.swift
//  Swish
//
//  Created by Clay Mills on 4/12/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UICollectionViewDelegate {

    var userAvatar = UIImage()
    var shots: [Shot] = []
    var collectionView = UICollectionView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView.DataSource = self
//        collectionView.Delegate = self
//        
//        // fetch all shots
//        ApiController.loadShots(page: String(page)) { (shots) in
//            self.shots = shots
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
        }
   
    func collectionViewReusableView(_ collectionView: UICollectionReusableView, numberOfItemsInSection section: Int) -> Int {
        return shots.count
    }
    
//    func collectionView(_ collectionView: UICollectionReusableView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.reuseIdentifier(withReuseIdentifier: "userShotCell", for: indexPath) as? LikedShotCollectionViewCell else { return UICollectionViewCell() }
//    
//        let shot = shots[indexPath.row]
//        return cell
//    }




    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
 
    
}
