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
        
        // FIXME: Change clientID to not use David's app registered with Dribble
        if let url = URL(string: "https://dribbble.com/oauth/authorize?client_id=\(DribbleApi.clientID)&scope=\(DribbleApi.scope)") {
            let request = URLRequest(url: url)
            authWebView.loadRequest(request)
        }
        
        // Observer is where the selector lives
        NotificationCenter.default.addObserver(self, selector: #selector(accessTokenWasRecievedFrom(notification:)), name: accessTokenRecievedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(accessTokenWasDenied), name: accessTokenDeniedNotification, object: nil)
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
        _ = Keychain.set(accessToken, forKey: "accessToken")
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func accessTokenWasDenied() {
        let deniedAlertController = UIAlertController(title: "Deny Access?", message: "To use Swish you must allow us to access your Dribbble account", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in })
        let denyAction = UIAlertAction(title: "Deny", style: .default, handler: { (_) in
            _ = self.navigationController?.popViewController(animated: true)
        })
        
        deniedAlertController.addAction(cancelAction)
        deniedAlertController.addAction(denyAction)
        
        present(deniedAlertController, animated: true, completion: nil)
    }
}
