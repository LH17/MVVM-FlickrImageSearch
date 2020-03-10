//
//  AppDelegate.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let appDIContainer = AppDIContainer()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppAppearance.setupAppearance()
            
        window = UIWindow(frame: UIScreen.main.bounds)
        let imagesSearchViewController = appDIContainer.imagesSceneDIContainer().makeImagesSearchViewController()
        window?.rootViewController = UINavigationController(rootViewController: imagesSearchViewController)
        window?.makeKeyAndVisible()
        return true
    }
}

