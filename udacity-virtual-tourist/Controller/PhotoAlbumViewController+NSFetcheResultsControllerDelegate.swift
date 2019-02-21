//
//  PhotoAlbumViewController+NSFetcheResultsControllerDelegate.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/17.
//  Copyright © 2019年 尾山昌太郎. All rights reserved.
//

import Foundation
import CoreData

extension PhotoAlbumViewController:  NSFetchedResultsControllerDelegate {
    
    func getStoredPhoto(url: URL, completion: @escaping (FlickrPhoto?, Error?) -> Void) {
        let fetchRequest:NSFetchRequest<FlickrPhoto> = FlickrPhoto.fetchRequest()
        let predicate1 = NSPredicate(format: "pindata == %@", pinData)
        let predicate2 = NSPredicate(format: "photoURL == %@", url as CVarArg)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        fetchRequest.predicate = predicate
        do {
            let result = try dataController.viewContext.fetch(fetchRequest)
            completion(result.first, nil)
        } catch {
            completion(nil, error)
        }
        
    }
    
}
