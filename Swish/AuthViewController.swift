//
//  AuthViewController.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/10/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController, UIWebViewDelegate {
    
    //MARK: - Properties
    
    //MARK: - Outlets 
    
    @IBOutlet weak var authWebView: UIWebView!
    
    //MARK: - View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authWebView.delegate = self
        
        updateViews()
        
        if let url = URL(string: "https://dribbble.com/oauth/authorize") {
            let request = URLRequest(url: url)
            authWebView.loadRequest(request)
        }
    }
    
    //MARK: - Helpers
    
    func updateViews() {
        
        navigationController?.navigationBar.backgroundColor = Colors.primaryPink
        navigationController?.navigationBar.barTintColor = Colors.primaryPink
        navigationController?.navigationBar.tintColor = .white
        
    }

}
