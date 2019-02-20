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
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        let destinationURL = localFilePath(for: sourceURL)
        // Store URL into Core Data
        let flickrPhoto = FlickrPhoto(context: dataController.viewContext)
        flickrPhoto.photoURL = destinationURL
        flickrPhoto.pindata = pinData
        try? dataController.viewContext.save()
        // Store Image into Library
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
        print("downloadLocation:", location)
        print("storedLocation:", destinationURL)
        
        // Change Download Status
        // Get Cell/Download Index
        let url = downloadTask.originalRequest?.url
        //let downloadIndex = downloadService.getDownloadIndex(url: url!)
        
        // Set Download Status
        let download = downloadService.getDownloadSessionStatus(url: url!) //downloadService.getDownloadSessionStatus(index: downloadIndex)
        download.isDownloading = false
        let data = try? Data(contentsOf: destinationURL)
        download.downloadedURL = sourceURL
        download.downloadedImage = UIImage(data: data!)
        
        DispatchQueue.main.async {
            self.photoAlbumCollectionView.reloadData()
        }
        
    }
    

    // Updates progress info
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        // Get Cell/Download Index
        let url = downloadTask.originalRequest?.url
        //let downloadIndex = downloadService.getDownloadIndex(url: url!)
        
        // Set Download Status
        //let download = downloadService.getDownloadSessionStatus(index: downloadIndex)
        let download = downloadService.getDownloadSessionStatus(url: url!)
        download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        download.isDownloading = true
        
        // Refresh ProgressBar in View
        DispatchQueue.main.async {
            self.photoAlbumCollectionView.reloadData()
        }
        print("test")
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

