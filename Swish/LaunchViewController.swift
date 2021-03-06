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

    var launchPageViewController: LaunchPageViewController? {
        didSet {
            launchPageViewController?.launchDelegate = self
        }
    }
    
    //MARK: - UI Actions
    @IBAction func signInButtonTapped(_ sender: Any) {}
    
    
    //MARK: - View lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(callRateLimitAlertController), name: presentAPIAlertControllerNotification, object: nil)
        
        pageControl.addTarget(self, action: #selector(LaunchViewController.didChangePageControlValue), for: .valueChanged)
        
        navigationController?.navigationBar.isHidden = true
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    // MARK: Observer Functions
    func callRateLimitAlertController() {
        DribbleApi.presentAPIInfoAlertController(view: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let launchPageViewController = segue.destination as? LaunchPageViewController {
            self.launchPageViewController = launchPageViewController
        }
    }
    func didChangePageControlValue() {
        launchPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if Keychain.value(forKey: "accessToken") != nil {
            UserController.fetchAuthenticatedUser(completion: { (authenticatedUser) in
                
                DispatchQueue.main.async {
                    guard let authenticatedUser = authenticatedUser else { return }
                    DribbleApi.currentUser = authenticatedUser
                    
                    self.performSegue(withIdentifier: "toSwipeVC", sender: self)
                }
            })
        } else if Keychain.value(forKey: "accessToken") == nil {
            self.updateViews()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK: - Helpers
    
    func updateViews() {
        
        self.containerView.backgroundColor = .white
        
        signInButton.backgroundColor = Colors.buttonPink
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





