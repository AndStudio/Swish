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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shotCell", for: indexPath) as? LikedShotCollectionViewCell else { return UICollectionViewCell() }
        
        cell.shot = shots[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation
    // FIXME: Link it to the correct VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShotDetailVC" {
            guard
                let index = collectionView.indexPathsForSelectedItems?.first,
                let destinationVC = segue.destination as? ShotDetailViewController
                else { return }
            
            let shot = shots[index.row]
            destinationVC.shot = shot
        }
    }
    
    //MARK: Pagination Properties and Functions
    let threshold: CGFloat = 100
    var page: Int = 1
    var isLoadingShots = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // when the user scrolls to a certain distance from the bottom of the content view a new API call will be made to append the next set of shots to the shot array
        
        let contentOffset = scrollView.contentOffset.y
        let maximumPossibleOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let offsetDifference = maximumPossibleOffset - contentOffset
        
        if !isLoadingShots && (offsetDifference < threshold) {
            self.page += 1
            ApiController.fetchLikedShots(page: String(page), completion: { (shots) in
                self.shots.append(contentsOf: shots)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            })
        }
    }
}









