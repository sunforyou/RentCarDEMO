//
//  JKAnnotation.swift
//  LBSRentCar
//
//  Created by 宋旭 on 16/4/15.
//  Copyright © 2016年 sky. All rights reserved.
//

import UIKit
import MapKit

class JKAnnotation: NSObject, MKAnnotation {

    private var myCoordinate: CLLocationCoordinate2D
    
    /**
     *  which will be the annotationView's image
     */
    var image: UIImage
    var tag: NSInteger
    
    init(myCoordinate: CLLocationCoordinate2D, image: UIImage, tag: NSInteger) {
        self.myCoordinate = myCoordinate
        self.image = image
        self.tag = tag
        super.init()
    }
    
    var coordinate: CLLocationCoordinate2D {
        return myCoordinate
    }
    
}
