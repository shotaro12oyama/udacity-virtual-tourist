//
//  Fetch.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/21.
//  Copyright © 2019 尾山昌太郎. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Fetch {
    static var photoImages: [Int: UIImage] = [:]
    
    
    
    class func setFetchImages(urls: [URL], completion: @escaping (Bool, Error?) -> Void) {
        for (index, url) in urls.enumerated() {
            let data = try? Data(contentsOf: url)
            photoImages.updateValue(UIImage(data: data!)!, forKey: index)
        }
    }
    
    class func addFetchImage(index: Int, url: URL) {
        let data = try? Data(contentsOf: url)
        photoImages.updateValue(UIImage(data: data!)!, forKey: index)
    }
    
    class func getFetchAllImages() -> [UIImage] {
        var imageArray: [UIImage] = []
        for item in photoImages.values {
            imageArray.append(item)
        }
        return imageArray
    }
    
    class func getFetchImage(index: Int) -> UIImage? {
        return photoImages[index]
    }
    
    
    class func deleteFetchImages() {
        photoImages.removeAll()
    }
    
}
