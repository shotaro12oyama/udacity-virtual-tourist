//
//  FlickrResponse.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/07.
//  Copyright © 2019 尾山昌太郎. All rights reserved.
//

import Foundation


struct FlickrResponse: Codable {
    let photos: PhotoData
    
}

struct PhotoData: Codable {
    let page: Int
    let pages: Int
    let photo: [PhotoInfo]
}

struct PhotoInfo: Codable {
    let farm: Int
    let server: String
    let id: String
    let secret: String
    let ispublic: Int
}


