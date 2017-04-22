//
//  DribbbleApi.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/11/17.
//  Copyright © 2017 And. All rights reserved.
//

import Foundation

class DribbleApi {

    static let clientID = "7e3ecb0581a0c7346f00029b96826f0267e92ec0a16759eeefaeafec841ff762"
    static let clientSecret = "8a8fad391aff41852cd8dd52d7f54f97e050014d3bfa1682538cd8ade9243be8"
    static let clientAccessKey = "a1590f48ee53ae2d172f3c49a444ce3d658e92cf7c95a91cc39eebbd4c5197cd"
    static let scope = "public+write"
    
    static let swipeShotsToLoad = 10
    static let collectionShotsToLoad = 20
    
    static var currentUser: User?
    
}
