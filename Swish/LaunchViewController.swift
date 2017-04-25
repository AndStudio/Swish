//
//  LaunchViewController.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/10/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    
    //MARK: - Outlets
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    //MARK: - Properties

    
    //MARK: - UI Actions
    // FIXME: No action in here, do we need this?
    @IBAction func signInButtonTapped(_ sender: Any) {

    }
    var launchPageViewController: LaunchPageViewController? {
        didSet {
            launchPageViewController?.launchDelegate = self
        }
    }
    
    //MARK: - View lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.addTarget(self, action: #selector(LaunchViewController.didChangePageControlValue), for: .valueChanged)
        
        navigationController?.navigationBar.isHidden = true
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let launchPageViewController = segue.destination as? LaunchPageViewController {
            self.launchPageViewController = launchPageViewController
        }
    }
    func didChangePageControlValue() {
        launchPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Keychain.value(forKey: "accessToken") != nil {
            UserController.fetchAuthenticatedUser(completion: { (authenticatedUser) in
                
                DispatchQueue.main.async {
                    guard let authenticatedUser = authenticatedUser else { /*FIXME: Add error alert controller */ return }
                    DribbleApi.currentUser = authenticatedUser
                    
                    self.performSegue(withIdentifier: "toSwipeVC", sender: self)
                }
            })
        }
    }
    
    //MARK: - Helpers
    
    func updateViews() {
        
        self.containerView.backgroundColor = Colors.dribbbleGray
        
        signInButton.backgroundColor = Colors.primaryPink
        signInButton.setTitle("Sign in", for: .normal)
        signInButton.tintColor = .white
        signInButton.layer.cornerRadius = 5
        signInButton.clipsToBounds = true
        
    }
    
}

extension LaunchViewController: LaunchPageViewControllerDelegate {
    
    func launchPageViewController(_ launchPageViewController: LaunchPageViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func launchPageViewController(_ launchPageViewController: LaunchPageViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
}





