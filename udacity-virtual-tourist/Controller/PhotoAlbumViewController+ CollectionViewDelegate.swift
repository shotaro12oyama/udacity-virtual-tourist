//
//  PhotoAlbumViewController+ CollectionViewDelegate.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/13.
//  Copyright © 2019年 尾山昌太郎. All rights reserved.
//

import Foundation
import UIKit

extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Initialize Cell
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoAlbumCollectionViewCell", for: indexPath) as! PhotoAlbumCollectionViewCell
        
        cell.progressBar.isHidden = true
        if let storedImage = Fetch.album[indexPath.item].imageData {
            cell.photoImageView.image = UIImage(data: storedImage)
        }
        
        // Receive Download Status
        if let download = downloadService.getDownloadSessionStatus(index: indexPath.item) {
        
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
                        cell.photoImageView.image = UIImage(data: Fetch.album[indexPath.item].imageData!)
                    }
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
        return Fetch.album.count;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = 0.2
        
        newCollectionButton.isHidden = true
        newCollectionButton.isEnabled = false
        
        removeSelectedPicturesButton.isHidden = false
        removeSelectedPicturesButton.isEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = 1.0
    }
    
    
    @IBAction func newCollectionButton (_ sender: Any) {
        
        getNewCollection()
        
    }
    
    
    
    @IBAction func removeSelectedPictures(_ sender: Any ) {
        
        removeSelectedPicturesButton.isHidden = true
        removeSelectedPicturesButton.isEnabled = false

        newCollectionButton.isHidden = false
        newCollectionButton.isEnabled = true
                
        if let items = photoAlbumCollectionView.indexPathsForSelectedItems {
            for selectedCell in items {
                let download = downloadService.getDownloadSessionStatus(index: selectedCell.item)
                deleteStoredPhoto(url: download!.imageURL)
                Fetch.album.remove(at: selectedCell.item)
                DispatchQueue.main.async {
                    self.photoAlbumCollectionView.reloadData()
                }
            }
            
        }

    }
    
    
    
}

