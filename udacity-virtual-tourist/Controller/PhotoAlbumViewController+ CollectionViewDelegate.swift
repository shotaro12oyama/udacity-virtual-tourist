//
//  PhotoAlbumViewController+ CollectionViewDelegate.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/13.
//  Copyright © 2019年 尾山昌太郎. All rights reserved.
//

import Foundation
import UIKit

extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoAlbumCollectionViewCell", for: indexPath) as! PhotoAlbumCollectionViewCell
        
        //var photoInput = URL(string: FlickrClient.PhotoDownload.photoURL[indexPath.item]!)
        
        //progressBar = UIProgressView(progressViewStyle: .default)
        //progressBar.layer.position = CGPoint(x: self.view.center.x, y: self.view.frame.height / 4)
        //self.view.addSubview(progressBar)
        DispatchQueue.main.async {
            //let data = try? Data(contentsOf: photoInput!)
            
            //cell.photoImageView.image = UIImage(data: data!)

            cell.progressBar = UIProgressView(progressViewStyle: .default)
            cell.progressBar.setProgress(0.1, animated: true)
            
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
        return FlickrClient.flickrImages.count;
    }
    
    
    @IBAction func newCollectionButton (_ sender: Any) {
        FlickrClient.getPhotolist() { flickrImages, error in
            for item in flickrImages {
                self.downloadService.downloadFlickr(item)
            }
        }
        self.photoAlbumCollectionView.reloadData()
    }
    
    
}
