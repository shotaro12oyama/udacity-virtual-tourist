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
    var progress: Float = 0.0
    
    let downloadService = DownloadService()
    lazy var downloadsSession: URLSession = {
        //    let configuration = URLSessionConfiguration.default
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    // Get local file path: download task stores tune here; AV player plays it.
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        //configuring flowLayout
        let space:CGFloat = 1.5
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)

        // Do any additional setup after loading the view.
                
        if let annotation = annotationSelected {
            let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
            self.mapView.setRegion(region, animated:true)
            self.mapView.addAnnotation(annotation)
        }
    
        
        FlickrClient.getPhotolist () { photoinfo , error in
            FlickrClient.getPhotoDownloadInfo(photoInfo: photoinfo) { success, error in
                if success {
                    self.photoAlbumCollectionView.reloadData()
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.photoAlbumCollectionView.reloadData()
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


extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoAlbumCollectionViewCell", for: indexPath) as! PhotoAlbumCollectionViewCell
        
        var photoInput = URL(string: FlickrClient.PhotoDownload.photoURL[indexPath.item]!)
        
        //progressBar = UIProgressView(progressViewStyle: .default)
        //progressBar.layer.position = CGPoint(x: self.view.center.x, y: self.view.frame.height / 4)
        //self.view.addSubview(progressBar)
        DispatchQueue.main.async {
            let data = try? Data(contentsOf: photoInput!)
            
           
            
            //cell.photoImageView.image = UIImage(data: data!)
            
            cell.progressBar = UIProgressView(progressViewStyle: .default)
            cell.progressBar.setProgress(self.progress, animated: true)
            
        }

        return cell
    }
    
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return FlickrClient.PhotoDownload.photoURL.count;
    }
    
    
    @IBAction func newCollectionButton (_ sender: Any) {
        FlickrClient.getPhotolist () { photoinfo , error in
            
        }
        self.photoAlbumCollectionView.reloadData()
    }
    
    
}
