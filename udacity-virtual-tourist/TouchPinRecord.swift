//
//  TouchPinRecord.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/06.
//  Copyright © 2019年 尾山昌太郎. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class TouchPinRecord {
    static var annotaions: [MKPointAnnotation] = []
    
    class func setTouchRecord(newRecord: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = newRecord
        annotation.title = title
        self.annotaions.append(annotation)
    }

}
