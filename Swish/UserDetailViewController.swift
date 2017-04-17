//
//  UserDetailViewController.swift
//  Swish
//
//  Created by Clay Mills on 4/12/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

private let reuseIdentifier = "userShotCell"

class UserDetailViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    var userAvatar = UIImage()
    var shots: [Shot] = []
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView.DataSource = self
//        collectionView.Delegate = self
        
        ApiController.loadShots { (shots) in
            DispatchQueue.main.async {
                self.shots = shots
            }
        }

        
        // adjust to fetch all shots, not just liked shots
//        ApiController.loadShots(page: String()) { (shots) in
//            self.shots = shots
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userShotCell", for: indexPath) as? UICollectionViewCell else { return UICollectionViewCell() }
        
        let shot = shots[indexPath.row]
        return cell
    }




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
