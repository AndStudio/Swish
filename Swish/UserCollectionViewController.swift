//
//  UserCollectionViewController.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/23/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

protocol ShotRefreshDelegate: class {
    
    func reloadShotDetailVCWith(selectedShot: Shot)
}

class UserCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Properties 
    
    var user: User? {
        didSet {
            DispatchQueue.main.async {
                guard self.isViewLoaded else { return }
                self.updateViews()
            }
        }
    }
    
    var maxPage: Int = 1
    var page: Int = 1
    var userAvatar = UIImage()
    var shots: [Shot] = []
    var shotRefreshDelegate: ShotRefreshDelegate?
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    
    //MARK: - UI Actions 
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let username = user?.userUserName else { return }
        
        title = "\(username)"
        
        navigationController?.isNavigationBarHidden = false

        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        view.backgroundColor = Colors.backgroundGray
        collectionView?.backgroundColor = Colors.backgroundGray
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        layout.itemSize = CGSize(width: screenWidth / 2 - 22, height: screenWidth/2 - 245)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        
        guard let user = user else { return }
        ApiController.fetchShots(forUser: user, page: String(page)) { (shots) in
            self.shots = shots
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                
                self.updateViews()
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 1
        case 1: return shots.count
        default: return 1
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as? HeaderCollectionViewCell else { return HeaderCollectionViewCell() }
            
            cell.user = user
            
            return cell
            
        case 1:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shotCell", for: indexPath) as? ShotCollectionViewCell else { return ShotCollectionViewCell() }
            
            
            let shot = shots[indexPath.row]
            shot.user = user
            cell.shot = shot
            
            return cell
            
        default:
            let cell = UICollectionViewCell()
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 260)
        } else {
            return CGSize(width: screenWidth / 2 - 8, height: screenWidth / 2 - 65)
        }
    }
    
    
    //MARK: - Pagination 
    //FIXME: - Pagination doesnt work with mulitple secion indexs
    
    /*
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
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
                        
                        self.collectionView?.insertItems(at: newShotsIndexPaths)
                    }
                }
            })
        }
    }
    */
    
    //MARK: - Helper Methods
    
    func updateViews() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = Colors.primaryPink
    }
    
    //MARK: -  segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShot" {
            guard let indexPath = collectionView?.indexPathsForSelectedItems?.first,
                let navController = segue.destination as? UINavigationController, let destinationVC = navController.childViewControllers.first as? ShotDetailViewController else { return }
            let shot = shots[indexPath.row]
            shot.isDismisable = false
            destinationVC.shot = shot
        }
    }
}






