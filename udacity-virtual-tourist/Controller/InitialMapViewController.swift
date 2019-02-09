//
//  InitialMapViewController.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/06.
//  Copyright © 2019年 尾山昌太郎. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class InitialMapViewController: UIViewController,  MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    var dataController: DataController!
    
    //var fetchedResultsController: NSFetchedResultsController<PinData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest: NSFetchRequest<PinData> = PinData.fetchRequest()
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            var annotations: [MKPointAnnotation] = []
            for item in result {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
                annotation.title = item.title
                annotations.append(annotation)
            }
            self.mapView.addAnnotations(annotations)
            

        }
        
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


    // This delegate method is implemented to respond to taps. 
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let detailController = self.storyboard!.instantiateViewController(withIdentifier: "PhotoAlbumViewController") as! PhotoAlbumViewController
                 self.navigationController!.pushViewController(detailController, animated: true)
            detailController.annotationSelected = view.annotation
            detailController.dataController = dataController
            
        }
    }
 
    
    @IBAction func mapViewDidTap(_ sender: Any) {
        if (sender as AnyObject).state == UIGestureRecognizer.State.ended {
            let tapPoint = (sender as AnyObject).location(in: mapView)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            TouchPinRecord.setTouchRecord(newRecord: center)
            
            let pinData = PinData(context: dataController.viewContext)
            pinData.lat = center.latitude
            pinData.lon = center.longitude

            let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                guard let placemark = placemarks?.first, error == nil else { return }
                pinData.title = "\(placemark.locality ?? "Unknown")" + ", " + "\(placemark.administrativeArea ?? "Unknown")"
            }
            
            try? dataController.viewContext.save()

            self.mapView.addAnnotations(TouchPinRecord.annotaions)
        }
    }
    
}
