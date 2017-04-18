//
//  Formatters.swift
//  Swish
//
//  Created by Taylor Phillips on 4/18/17.
//  Copyright © 2017 And. All rights reserved.
//

import Foundation
import UIKit

class Formatters {
    static func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let datea = formatter.date(from: dateString)
        formatter.dateFormat = "MMM dd, yyyy"
        guard let date = datea else { return "" }
            
            return formatter.string(from: date)
        
    }
    
    static func stripHTML(_ description: NSString) -> String {
        var stringToStrip = description
        var string = stringToStrip.range(of: "<.*?>", options: .regularExpression)
        while string.location != NSNotFound {
            stringToStrip = stringToStrip.replacingCharacters(in: string, with: "") as NSString
            string = stringToStrip.range(of: "<.*?>", options: .regularExpression)
        }
        return stringToStrip as String
    }
}
