//
//  JKModel.swift
//  LBSRentCar
//
//  Created by 宋旭 on 16/4/14.
//  Copyright © 2016年 sky. All rights reserved.
//

import UIKit

class JKModel: NSObject {
    
    var name: String?
    var picture: String?
    var price: String?
    var distance: String?
    var location: String?
    var information: String?
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

