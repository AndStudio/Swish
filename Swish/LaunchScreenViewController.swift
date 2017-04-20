//
//  LaunchScreenViewController.swift
//  Swish
//
//  Created by Work on 4/19/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        _ = Keychain.removeValue(forKey: "accessToken")
        
        if Keychain.value(forKey: "accessToken") != nil {
            UserController.fetchAuthenticatedUser(completion: { (authenticatedUser) in
                
                DispatchQueue.main.async {
                    guard let authenticatedUser = authenticatedUser else { self.performSegue(withIdentifier: "toLaunchVC", sender: self); return }
                    DribbleApi.currentUser = authenticatedUser
                    
                    self.performSegue(withIdentifier: "toSwipeVCFromLaunch", sender: self)
                }
            })
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toLaunchVC", sender: self)
            }
        }
    }
    
    func viewWill() {
        super.viewDidLoad()
        
    }
}
