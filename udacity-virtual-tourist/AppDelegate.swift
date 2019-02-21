//
//  AppDelegate.swift
//  udacity-virtual-tourist
//
//  Created by 尾山昌太郎 on 2019/02/05.
//  Copyright © 2019年 尾山昌太郎. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundSessionCompletionHandler: (() -> Void)?

    let dataController = DataController(modelName: "PhotoDownloadData")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        dataController.load()
        let navigationController = window?.rootViewController as! UINavigationController
        let initialMapViewController = navigationController.topViewController as! InitialMapViewController
        initialMapViewController.dataController = dataController
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
    

  
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveViewContext()
    }
    
    func saveViewContext() {
        try? dataController.viewContext.save()
    }

}

