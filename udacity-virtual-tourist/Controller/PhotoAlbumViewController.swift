//
//  PhotoAlbumViewController.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/06.
//  Copyright © 2019 尾山昌太郎. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var photoAlbumCollectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    var annotationSelected: MKAnnotation?
    var dataController:DataController!
    
    let downloadService = DownloadService()
    lazy var downloadSession: URLSession = {
        //    let configuration = URLSessionConfiguration.default
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // Configure flowLayout
        let space:CGFloat = 1.5
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)

        // Do any additional setup after loading the view.
        // Show Annotation Pin on the map
        if let annotation = annotationSelected {
            let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
            self.mapView.setRegion(region, animated:true)
            self.mapView.addAnnotation(annotation)
        }
    
        // Start Download
        
        downloadService.downloadSession = downloadSession
        FlickrClient.getPhotolist() { flickrImages, error in
            for item in flickrImages {
                self.downloadService.downloadFlickr(item)
            }
        }
        DispatchQueue.main.async {
            self.photoAlbumCollectionView.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.photoAlbumCollectionView.reloadData()
        }
    }
    
    
    
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
}


