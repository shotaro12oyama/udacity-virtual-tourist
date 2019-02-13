//
//  FlickrImage.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/12.
//  Copyright © 2019 尾山昌太郎. All rights reserved.
//

import Foundation.NSURL

// Query service creates Track objects
class FlickrImage {
    
    let name: String
    let imageURL: URL
    var downloaded = false
    var downloadID: URLSessionDownloadTask?
    var index: Int
    var progess: Float = 0.0
    
    init(name: String, imageURL: URL, index: Int) {
        self.name = name
        self.imageURL = imageURL
        self.index = index
    }
    
}
