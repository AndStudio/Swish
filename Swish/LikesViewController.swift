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
        
        fetchLikedShots()
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // send selected shot to ShotDetailViewController
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
            fetchLikedShots()
            
            self.isLoadingShots = false
        }
    }
    
    // API Call to get liked Shots
    // Add a completion to the function and have the collection view reload the data
    func fetchLikedShots(/*completion: @escaping ([Shot]) -> Void*/) {
        // Example endpoint: https://api.dribbble.com/v1/user/likes?access_token=a1590f48ee53ae2d172f3c49a444ce3d658e92cf7c95a91cc39eebbd4c5197cd&per_page=20
        
        guard let likesBaseURL = URL(string: "https://api.dribbble.com/v1/user/likes") else { return }
        let urlParameters = [
            "access_token": NetworkController.accessToken,
            "per_page":"20",
            "page":String(self.page)
            ] as? [String:String]
        
        NetworkController.performRequest(for: likesBaseURL, httpMethod: .Get, urlParameters: urlParameters, body: nil) { (data, error) in
            if error != nil {
                NSLog("There was an error with the API to grab the user's liked shots: \(String(describing: error?.localizedDescription))")
            }
            
            guard let data = data else { return }
            
            guard let likedShotsDictionariesArray = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [[String:Any]] else { return }
            let likedShotsArray = likedShotsDictionariesArray.flatMap({ Shot(dictionary: $0) })
            
            self.shots.append(contentsOf: likedShotsArray)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }

}














