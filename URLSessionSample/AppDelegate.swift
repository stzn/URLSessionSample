//
//  AppDelegate.swift
//  URLSessionSample
//
//  Created by shiz on 2018/07/02.
//  Copyright © 2018年 shiz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundSessionCompletionHandler: (() -> Void)?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        
        backgroundSessionCompletionHandler = completionHandler
        
        let configuration = URLSessionConfiguration.background(withIdentifier: identifier)
        let session = URLSession(configuration: configuration, delegate: SearchViewController(), delegateQueue: nil)
        let downloadService = DownloadService()
        downloadService.session = session
    }
}

