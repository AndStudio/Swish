//
//  ShotDetailViewController.swift
//  Swish
//
//  Created by Taylor Phillips on 4/13/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class ShotDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AboutShotCellDelegate, ShotRefreshDelegate {
    
    
    //MARK: - Properties
    
    var shot: Shot? {
        didSet {
            DispatchQueue.main.async {
                guard self.isViewLoaded else { return }
                self.updateViews()
            }
        }
    }
    
    
    //MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    
    
    //MARK: - Actions 
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        updateViews()
    }
    
    
    func reloadShotDetailVCWith(selectedShot: Shot) {
        self.shot = selectedShot
    }
    
    
    //MARK: - Helper fucntions
    
    func updateViews() {
        guard let shot = shot else { return }
        
        view.backgroundColor = Colors.backgroundGray
        tableView.backgroundColor = .clear
        
        
    }
    
    //MARK: - Tableview Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "hero", for: indexPath) as? ShotHeroTableViewCell else { return ShotHeroTableViewCell() }
            
            cell.shot = shot
            heroCell = cell
            cell.separatorInset.left = 900
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "title", for: indexPath) as? ShotDetailTitleTableViewCell else { return ShotDetailTitleTableViewCell() }
            
            cell.shot = shot
            
            cell.separatorInset.left = 16
            cell.separatorInset.right = 16
            
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "about", for: indexPath) as? AboutShotTableViewCell else { return AboutShotTableViewCell() }
            
            cell.shot = shot
            cell.delegate = self
            
            cell.separatorInset.left = 900
            
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "description", for: indexPath) as? ShotDescriptionTableViewCell else { return ShotDescriptionTableViewCell() }
            
            cell.shot = shot
            
            cell.separatorInset.left = 16
            cell.separatorInset.right = 16
            
            return cell
            
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "designer", for: indexPath) as? ShotDesignerTableViewCell else { return ShotDesignerTableViewCell() }
            
            cell.shot = shot
            
            cell.separatorInset.left = 900
            
            return cell
            
        default:
            let cell = UITableViewCell()
            
            cell.separatorInset.left = 900
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return UITableViewAutomaticDimension
        case 1: return UITableViewAutomaticDimension
        case 2: return UITableViewAutomaticDimension
        case 2: return UITableViewAutomaticDimension
        case 3: return UITableViewAutomaticDimension
        case 4: return 144
        default: return 200
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    //MARK: - AboutCell Delegate
    
    func userButtonTapped(_ sender: AboutShotTableViewCell) {
        
        let userStoryboard = UIStoryboard(name: "User", bundle: nil)
        
        guard let userDetailVC = userStoryboard.instantiateViewController(withIdentifier: "user") as? UserDetailViewController else { return }
        
        userDetailVC.user = shot?.user
        self.present(userDetailVC, animated: true, completion: nil)
    }
    

    func shareButtonTapped(_ sender: AboutShotTableViewCell) {
        guard let shot = self.shot else { return }
        let image = shot.largeImage
        let activiityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activiityViewController, animated: true, completion: nil)
    }

    
    //MARK: - TableView detect scroll
    
    var heroCell: ShotHeroTableViewCell?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let cell = heroCell {
            
            if scrollView.contentOffset.y < 0 {
                cell.heroTopConstraint.constant = scrollView.contentOffset.y
            }
            
        }
        
    }
    
    //MARK: - Segue to User
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUser" {
            
            guard let destinationVC = segue.destination as? UserDetailViewController else { return }
            let userData = shot?.user
            destinationVC.user = userData
            
        }
    }
}







