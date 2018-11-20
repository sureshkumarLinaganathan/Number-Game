//
//  Theme.swift
//  Number Game
//
//  Created by Natarajan on 20/11/18.
//  Copyright © 2018 Suresh Kumar. All rights reserved.
//

import UIKit

class Theme: NSObject {
   
    static func bigNumberColor()->UIColor{
        return UIColor.init(red:235.0/255.0, green:77.0/255.0, blue: 174.0/255.0, alpha:1.0)
    }
    static func smallNumberColor()->UIColor{
        return UIColor.init(red: 235.0/255.0, green: 78.0/255.0, blue: 89.0/255.0, alpha:1.0)
    }
}
