//
//  PhotoAlbumViewController+URLSessionDelegate.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/12.
//  Copyright © 2019 尾山昌太郎. All rights reserved.
//

import Foundation
import UIKit

extension PhotoAlbumViewController: URLSessionDownloadDelegate {
    

    // Stores downloaded file
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        // Store Downloaded Image
        guard let url = downloadTask.originalRequest?.url else { return }
       
        // Store URL into Core Data
        if let data = try? Data(contentsOf: location) {
            let flickrPhoto = FlickrPhoto(context: dataController.viewContext)
            flickrPhoto.photoURL = url
            flickrPhoto.pindata = pinData
            flickrPhoto.imageData = data
        }
        try? dataController.viewContext.save()
        
        // Change Download Status
        // Get Cell/Download Index
        
        // Set Download Status
        if let download = downloadService.getDownloadSessionStatus(url: url) {
            download.isDownloading = false
            DispatchQueue.main.async {
                self.photoAlbumCollectionView.reloadData()
            }
        }
        
    }
    

    // Updates progress info
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        // Get Cell/Download Index
        let url = downloadTask.originalRequest?.url
        
        // Set Download Status
        if let download = downloadService.getDownloadSessionStatus(url: url!) {
            download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            download.isDownloading = true
            
            // Refresh ProgressBar in View
            DispatchQueue.main.async {
                self.photoAlbumCollectionView.reloadData()
            }
        }
    }
    
    // Standard background session handler
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                completionHandler()
            }
        }
    }
    
    
}

