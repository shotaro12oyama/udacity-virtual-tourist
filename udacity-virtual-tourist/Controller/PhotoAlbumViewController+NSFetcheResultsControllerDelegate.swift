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
    
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<FlickrPhoto> = FlickrPhoto.fetchRequest()
        let predicate = NSPredicate(format: "pinData == %@", pinData)
        fetchRequest.predicate = predicate
        //let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = nil
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
}
