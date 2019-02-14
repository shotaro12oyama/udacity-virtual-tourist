//
//  Download.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/13.
//  Copyright © 2019 尾山昌太郎. All rights reserved.
//

import Foundation

class Download {
    
    // Download service sets these values:
    var flickrImage: FlickrImage
    init (flickrImage: FlickrImage) {
        self.flickrImage = flickrImage
        self.imageURL = flickrImage.imageURL
    }
    
    var task: URLSessionDownloadTask?
    var isDownloading = false
    var resumeData: Data?
    var imageURL: URL?
    
    // Download delegate sets this value:
    var progress: Float = 0

}

class DownloadService {
    
    // ViewController creates downloadsSession
    var downloadSession: URLSession!
    var activeDownloads: [URL: Download] = [:]
    var indexDownloads: [Int: URL] = [:]
    
    func downloadFlickr (_ flickrImage: FlickrImage) {
        let download = Download(flickrImage: flickrImage)
        download.task = downloadSession.downloadTask(with: flickrImage.imageURL)
        download.task!.resume()
        download.isDownloading = true
        activeDownloads[download.imageURL!] = download
        indexDownloads[flickrImage.index] = download.imageURL!
    }
    
    func progressWithIndex (index : Int) -> Float {
        let url = indexDownloads[index]
        let download = activeDownloads[url!]
        
        var progress: Float = 0.0
        
        return progress
    }
}
