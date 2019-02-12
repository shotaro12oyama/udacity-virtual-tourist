//
//  Download.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/12.
//  Copyright © 2019 尾山昌太郎. All rights reserved.
//

import Foundation

// Download service creates Download objects
class Download {
    
    var flickrImage: FlickrImage
    init(flickrImage: FlickrImage) {
        self.flickrImage = flickrImage
    }
    
    // Download service sets these values:
    var task: URLSessionDownloadTask?
    var isDownloading = false
    var resumeData: Data?
    
    // Download delegate sets this value:
    var progress: Float = 0
    
}
