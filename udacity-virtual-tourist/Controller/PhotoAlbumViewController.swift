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
    @IBOutlet var removeSelectedPicturesButton: UIButton!
    @IBOutlet weak var photoAlbumCollectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    var annotationSelected: MKAnnotation?
    var dataController:DataController!
    var pinData: PinData!
    var downloadedImage: [URL] = []

    
    // Prepare Download
    let downloadService = DownloadService()
    lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    // Prepare Core Data
    var fetchedResultsController:NSFetchedResultsController<FlickrPhoto>!
    
    // View
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Configure flowLayout
        let space:CGFloat = 1.5
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        photoAlbumCollectionView.allowsMultipleSelection = true
        
        // Show Annotation Pin on the map
        if let annotation = annotationSelected {
            let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
            self.mapView.setRegion(region, animated:true)
            self.mapView.addAnnotation(annotation)
        }
        
        print("fetch_count: ", Fetch.album.count)
        // Prepare Download Service
        downloadService.downloadSession = downloadSession
        
        if Fetch.album.count == 0 {
            let fetchRequest:NSFetchRequest<FlickrPhoto> = FlickrPhoto.fetchRequest()
            let predicate = NSPredicate(format: "pindata == %@", pinData)
            fetchRequest.predicate = predicate
            if let result = try? dataController.viewContext.fetch(fetchRequest) {
                for item in result {
                    Fetch.album.append(item)
                }
            }
            // If no Stored Image, Start Download
            if Fetch.album.count == 0 {
                getNewCollection()
            }
        }
        
        removeSelectedPicturesButton.isHidden = true
        removeSelectedPicturesButton.isEnabled = false
        
    }
    
    
    
    func getNewCollection() {
        
        Fetch.album = []
        let fetchRequest:NSFetchRequest<FlickrPhoto> = FlickrPhoto.fetchRequest()
        let predicate = NSPredicate(format: "pindata == %@", pinData)
        fetchRequest.predicate = predicate
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            for item in result {
                dataController.viewContext.delete(item)
            }
            try? dataController.viewContext.save()
        }
        
        FlickrClient.removePhotoList()
        downloadService.removeDownload()
        
        FlickrClient.getPhotolist() { flickrImages, error in
            // When get the download list, Reflect to CollectionView
            if error != nil {
                print(error!)
            } else {
                for item in flickrImages {
                    self.downloadService.downloadFlickr(flickrImage: item)
                }
                DispatchQueue.main.async {
                    self.photoAlbumCollectionView.reloadData()
                }
            }
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


