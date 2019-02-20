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
            cell.photoImageView.image = download.downloadedImage
            cell.progressBar.isHidden = true
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
        getNewCollection()
    }
    
    
}
