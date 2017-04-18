//
//  LikesViewController.swift
//  Swish
//
//  Created by Work on 4/12/17.
//  Copyright © 2017 And. All rights reserved.
//


import UIKit

class LikesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Properties
    var shots: [Shot] = []
    
    // MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        ApiController.fetchLikedShots(page: String(page)) { (shots) in
            self.shots = shots
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: Delegat and Data Source Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedShotCell", for: indexPath) as? LikedShotCollectionViewCell else { return UICollectionViewCell() }
        
        cell.shot = shots[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation
    // FIXME: Link it to the correct VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShotDetailVC" {
            guard
                let index = collectionView.indexPathsForSelectedItems?.first,
                let destinationVC = segue.destination as? ShotDetailViewController,
                let test = String?("test")
                else { return }
            
            let shot = shots[index.row]
            destinationVC.shot = shot
        }
    }
    
    //MARK: Pagination Properties and Functions
    let threshold: CGFloat = 300
    var page: Int = 1
    var isLoadingShots = false
    var maxPage: Int = 1

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let authenticatedUser = UserController.currentUser else { return }
        let doubleCount = Double(authenticatedUser.likeCount)
        self.maxPage = Int(ceil(doubleCount / 20.0))
        
        if indexPath.row == (self.shots.count - 5) && self.page <= maxPage {
            self.page += 1
            ApiController.fetchLikedShots(page: String(page), completion: { (shots) in
                
                let oldShotsEndIndex = self.shots.endIndex
                self.shots.append(contentsOf: shots)
                DispatchQueue.main.async {
                    if self.page < self.maxPage {
                        let newShotsEndIndex = self.shots.endIndex - 1
                        let newShotsIndexPaths = (oldShotsEndIndex...newShotsEndIndex).map({IndexPath(item: $0, section: 0)})
                        
                        self.collectionView.insertItems(at: newShotsIndexPaths)
                        self.isLoadingShots = false
                        
                    }
                }
            })
        }
    }
}

