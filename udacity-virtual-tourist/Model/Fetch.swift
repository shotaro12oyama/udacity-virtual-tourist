//
//  Fetch.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/21.
//  Copyright © 2019 尾山昌太郎. All rights reserved.
//

import Foundation
import UIKit

class Fetch {
    static var album: [FlickrPhoto] = []
    
    func addAlbum(_ photo: FlickrPhoto) {
        Fetch.album.append(photo)
    }
    
    func removeAlbum() {
        Fetch.album.removeAll()
    }
    
}
