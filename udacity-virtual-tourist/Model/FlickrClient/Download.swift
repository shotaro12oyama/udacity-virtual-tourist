//
//  Download.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/13.
//  Copyright © 2019 尾山昌太郎. All rights reserved.
//

import Foundation
import UIKit

class Download {
    
    // Download service sets these values:
    var flickrImage: FlickrImage
    var imageURL: URL
    init (flickrImage: FlickrImage) {
        self.flickrImage = flickrImage
        self.imageURL = flickrImage.imageURL
    }
    
    var task: URLSessionDownloadTask?
    var sharedTask: URLSessionDataTask?
    var isDownloading = false
    var downloadedImage: UIImage?
    var downloadedURL: URL?
    var progress: Float = 0

}


class DownloadService {
    
    // ViewController creates downloadsSession
    var downloadSession: URLSession!
    var downloads: [URL: Download] = [:]
    
    func downloadFlickr (flickrImage: FlickrImage) {
        if downloads[flickrImage.imageURL] == nil {
            let download = Download(flickrImage: flickrImage)
            download.task = downloadSession.downloadTask(with: flickrImage.imageURL)
            download.task!.resume()
            download.isDownloading = true
            downloads[flickrImage.imageURL] = download
        }
    }
    
    func getDownloadSessionStatus(index: Int) -> Download {
        let task = downloads[FlickrClient.flickrImages[index].imageURL]
        return task!
    }
    
    func getDownloadSessionStatus(url: URL) -> Download? {
        let task = downloads[url]
        return task
    }
    
    func removeDownload() {
        downloads.removeAll()
    }
}
