//
//  AuthViewController.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/10/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit
import OAuthSwift

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
        
        if let url = URL(string: "https://dribbble.com/oauth/authorize?client_id=7e3ecb0581a0c7346f00029b96826f0267e92ec0a16759eeefaeafec841ff762&scope=public+write") {
            let request = URLRequest(url: url)
            authWebView.loadRequest(request)
        }
        
        //selector is a functino that handles what should be done when the notification is recieved

        
        // Observer is where the selector lives
        NotificationCenter.default.addObserver(self, selector: #selector(accessTokenWasRecievedFrom(notification:)), name: accessTokenRecievedNotification, object: nil)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("starting load of \(request.url!)")
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print(#function)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print(#function)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("\(#function): \(error)")
    }
    
    //MARK: - Helpers
    
    func updateViews() {
        
        navigationController?.navigationBar.backgroundColor = Colors.primaryPink
        navigationController?.navigationBar.barTintColor = Colors.primaryPink
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    func accessTokenWasRecievedFrom(notification: Notification) {

        guard let accessToken = notification.userInfo?["accessToken"] as? String else { return }
        print(accessToken)
        Keychain.set(accessToken, forKey: "accessToken")
        
        _ = navigationController?.popViewController(animated: true)
        
    }    

    

}
