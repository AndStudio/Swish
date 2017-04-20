//
//  DribbbleApi.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/11/17.
//  Copyright © 2017 And. All rights reserved.
//

import Foundation

class DribbleApi {

    static let clientID = "e97282047496bac5ee671f3dd82e7e44789a3a011f10d1c8ba375aab4f93097f"
    static let clientSecret = "58770dac962283bdbd486ae4815d087654731bec8d3753a9e332c3069ebd5e8d"
    static let clientAccessKey = "70a3dded364357c7f618fd1eb28241ac19511cd0f2110ed34b8508d7e3217184"
    static let scope = "public+write"
    
    static let swipeShotsToLoad = 10
    static let collectionShotsToLoad = 20
    
    static var currentUser: User?
}
