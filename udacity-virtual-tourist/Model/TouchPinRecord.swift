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
    
    
    class func setTouchRecord(newRecord: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = newRecord
        let location = CLLocation(latitude: newRecord.latitude, longitude: newRecord.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else { return }
            annotation.title = "\(placemark.locality ?? "Unknown")" + ", " + "\(placemark.administrativeArea ?? "Unknown")"
        }
        self.annotaions.append(annotation)
    }

}
