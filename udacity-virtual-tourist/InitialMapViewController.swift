//
//  InitialMapViewController.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/06.
//  Copyright © 2019年 尾山昌太郎. All rights reserved.
//

import UIKit
import MapKit

class InitialMapViewController: UIViewController,  MKMapViewDelegate  {

    @IBOutlet weak var mapView: MKMapView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // Here we create the annotation and set its coordiate, title, and subtitle properties
        
    }

    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }


    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
 
    
    @IBAction func mapViewDidTap(_ sender: Any) {
        if (sender as AnyObject).state == UIGestureRecognizer.State.ended {
            let tapPoint = (sender as AnyObject).location(in: view)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            TouchPinRecord.setTouchRecord(newRecord: center, title: "TEST")
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            // When the array is complete, we add the annotations to the map.
            self.mapView.addAnnotations(TouchPinRecord.annotaions)
        }
    }
    
}
