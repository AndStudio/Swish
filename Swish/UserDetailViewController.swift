//
//  UserDetailViewController.swift
//  Swish
//
//  Created by Clay Mills on 4/12/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

// numberOfItemsInSection
// cellForItemAt
// 

//class UserDetailViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
//
//    var userAvatar = UIImage()
//    var shots: [Shot] = []
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        UICollectionView.DataSource = self
//        UICollectionView.Delegate = self
//        
//        // adjust to fetch all shots, not just liked shots
//        ApiController.fetchLikedShots(page: String(page)) { (shots) in
//            self.shots = shots
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
//
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return shots.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedShotCell", for: indexPath) as? LikedShotCollectionViewCell else { return UICollectionViewCell() }
//        
//        cell.shot = shots[indexPath.row]
//        return cell
//    }
//
//
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
