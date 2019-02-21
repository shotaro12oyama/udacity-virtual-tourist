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
        
        // Initialize Cell
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoAlbumCollectionViewCell", for: indexPath) as! PhotoAlbumCollectionViewCell
        
        // Receive Download Status
        let download = downloadService.getDownloadSessionStatus(index: indexPath.item)
        
        // Show the progrss status
        if download.isDownloading {
            cell.progressBar.isHidden = false
            cell.progressBar.setProgress(download.progress, animated: true)
        } else {
            getStoredPhoto(url: download.imageURL) {photodata, error in
                if error != nil {
                    print(error!)
                } else {
                    cell.progressBar.isHidden = true
                    cell.photoImageView.image = UIImage(data: photodata!.imageData!)
                }
            }
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoAlbumCollectionViewCell", for: indexPath) as! PhotoAlbumCollectionViewCell
        
        enum EditStatus {
            case selected
            case notSelected
        }
        
        newCollectionButton.isHidden = true
        
        
 
        
        
    }
    
    @IBAction func newCollectionButton (_ sender: Any) {
        getNewCollection()
    }
    
    
}
