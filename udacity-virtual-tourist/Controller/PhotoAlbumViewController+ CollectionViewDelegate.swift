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
        
        var progress: Float = 0.0
        var isDownloading: Bool = false
        
        if downloadedImage.count == 0 {
            if let download = downloadService.activeDownloads[FlickrClient.flickrImages[indexPath.item].imageURL] {
                progress = download.progress
                isDownloading = download.isDownloading
            } else {
                print("download object is nil")
            }
        
            //setupFetchedResultsController()

            DispatchQueue.main.async {
                if isDownloading {
                    cell.progressBar.isHidden = false
                    cell.progressBar.setProgress(progress, animated: true)
                } else {
                    cell.progressBar.isHidden = true
                    let data = try? Data(contentsOf: FlickrClient.flickrImages[indexPath.item].imageURL)
                    cell.photoImageView.image = UIImage(data: data!)
                }
            }
        } else {
            DispatchQueue.main.async {
                let downloadedImageURL = self.downloadedImage[indexPath.item]
                cell.progressBar.isHidden = true
                let data = try? Data(contentsOf: downloadedImageURL)
                cell.photoImageView.image = UIImage(data: data!)
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
    
    
    @IBAction func newCollectionButton (_ sender: Any) {
        FlickrClient.getPhotolist() { flickrImages, error in
            for item in flickrImages {
                self.downloadService.downloadFlickr(item)
            }
        }
        
        self.photoAlbumCollectionView.reloadData()
    }
    
    
}
