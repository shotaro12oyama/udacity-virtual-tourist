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
    @IBOutlet weak var deleteNotifyLabel: UILabel!
    
    var dataController: DataController!
    var editState: Bool = true
    var pinData: PinData!
    
    var fetchedResultsController: NSFetchedResultsController<PinData>!
    
    var annotations: [MKPointAnnotation] = []
    var pin: [NSManagedObjectID:MKPointAnnotation] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        deleteNotifyLabel.isHidden = true
        deleteNotifyLabel.isEnabled = false
        editState = true
        
        let fetchRequest: NSFetchRequest<PinData> = PinData.fetchRequest()
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            
            for item in result {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
                annotation.title = item.title
                annotations.append(annotation)
                pin.updateValue(annotation, forKey: item.objectID)

            }
            self.mapView.addAnnotations(annotations)

        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        editState = true
        super.viewWillAppear(animated)
        self.mapView.addAnnotations(annotations)
    }
    
    @objc func edit() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        deleteNotifyLabel.isEnabled = true
        deleteNotifyLabel.isHidden = false
        editState = false
        
        
    }

    @objc func done() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        deleteNotifyLabel.isHidden = true
        deleteNotifyLabel.isEnabled = false
        editState = true
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
            if editState {
                let detailController = self.storyboard!.instantiateViewController(withIdentifier: "PhotoAlbumViewController") as! PhotoAlbumViewController
                     self.navigationController!.pushViewController(detailController, animated: true)
                detailController.annotationSelected = view.annotation
                detailController.pinData = pinData
                detailController.dataController = dataController
            } else {
                let pinObjectID = pin.filter{$0.value == view.annotation as! MKPointAnnotation}.keys.first
                self.mapView.removeAnnotation(view.annotation!)
                dataController.viewContext.delete(dataController.viewContext.object(with: pinObjectID!))
                    
                try? dataController.viewContext.save()
            
            }
        }
    }
 
    
    @IBAction func mapViewDidTap(_ sender: Any) {
        if (sender as AnyObject).state == UIGestureRecognizer.State.ended {
            if editState {
                let tapPoint = (sender as AnyObject).location(in: mapView)
                let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
                
                pinData = PinData(context: dataController.viewContext)
                pinData.lat = center.latitude
                pinData.lon = center.longitude

                let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
                CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                    guard let placemark = placemarks?.first, error == nil else { return }
                    annotation.title = "\(placemark.locality ?? "Unknown")" + ", " + "\(placemark.administrativeArea ?? "Unknown")"
                    self.pinData.title = annotation.title
                }
                
                annotations.append(annotation)
                self.mapView.addAnnotation(annotation)
                pin.updateValue(annotation, forKey: pinData.objectID)

                try? dataController.viewContext.save()
                
            }
        }
    }
    
}
