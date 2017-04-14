//
//  AppDelegate.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/10/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

let accessTokenRecievedNotification = Notification.Name("Access Token Recieved")
let accessTokenDeniedNotification = Notification.Name("Access Token Denied")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var userAccessCode: String?

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if (url.host == "oauth") {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            guard
                let code = components?.queryItems?.first?.value,
                let baseURL = URL(string: "https://dribbble.com/oauth/token")
                else { return false }
            
            NSLog("THIS IS THE FIRST CODE:\(code)")
            
            if code == "access_denied" {
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: accessTokenDeniedNotification, object: self, userInfo: nil)
                }
                
            }
            
            let componentsDictionary: [String:String] = [
                "client_id":"7e3ecb0581a0c7346f00029b96826f0267e92ec0a16759eeefaeafec841ff762",
                "client_secret":"8a8fad391aff41852cd8dd52d7f54f97e050014d3bfa1682538cd8ade9243be8",
                "code":code
            ]
            
            NetworkController.performRequest(for: baseURL, httpMethod: .Post, urlParameters: componentsDictionary, body: nil, completion: { (data, error) in
                
                if let error = error {
                    NSLog("ERROR: \(error.localizedDescription)")
                    //completion(error)
                }
                
                guard
                    let data = data,
                    let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:Any],
                    let userAccessCode = json["access_token"] as? String
                else { return }
                
                self.userAccessCode = userAccessCode
                print("Access Code: \(String(describing: userAccessCode))")
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: accessTokenRecievedNotification, object: self, userInfo: ["accessToken":userAccessCode])
                }
            })

        }
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

