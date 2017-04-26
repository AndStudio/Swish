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
        
//        _ = Keychain.removeValue(forKey: "accessToken")
        print(Keychain.value(forKey: "accessToken") ?? "No Keychain value for \"accessToken\"")
        
        // FIXME: Remove this before shipping
        let currentAPIKeys = DribbleApi.dribbleAPIKeys.andrew
        
        switch currentAPIKeys {
        case .clay:
            DribbleApi.clientID = "4d2f9f854934b65d6b688f11241339f12778a2ef328d09d821c6c67a219235c5"
            DribbleApi.clientSecret = "e87e42a7efee0f5facee029f7f54798e13fff464a3b2939a54720f0f0d40e26e"
            DribbleApi.clientAccessKey = "d6eef742392bc554ebad0d5e186d240d03aa163f3f00bc5fe29d5b9eefb2f061"
            
        case .david:
            DribbleApi.clientID = "7e3ecb0581a0c7346f00029b96826f0267e92ec0a16759eeefaeafec841ff762"
            DribbleApi.clientSecret = "8a8fad391aff41852cd8dd52d7f54f97e050014d3bfa1682538cd8ade9243be8"
            DribbleApi.clientAccessKey = "a1590f48ee53ae2d172f3c49a444ce3d658e92cf7c95a91cc39eebbd4c5197cd"
            
        case .andrew:
            DribbleApi.clientID = "e97282047496bac5ee671f3dd82e7e44789a3a011f10d1c8ba375aab4f93097f"
            DribbleApi.clientSecret = "58770dac962283bdbd486ae4815d087654731bec8d3753a9e332c3069ebd5e8d"
            DribbleApi.clientAccessKey = "70a3dded364357c7f618fd1eb28241ac19511cd0f2110ed34b8508d7e3217184"
            
        case .taylor:
            DribbleApi.clientID = ""
            DribbleApi.clientSecret = ""
            DribbleApi.clientAccessKey = ""
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Keychain.removeValue(forKey: "accessToken")

        print(Keychain.value(forKey: "accessToken") ?? "No Keychain value for \"accessToken\"")
        
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
}
