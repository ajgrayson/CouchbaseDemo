//
//  AppDelegate.swift
//  CouchbaseDemo
//
//  Created by Johnathan Grayson on 16/11/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import UIKit

// Couchbase Database Name
private let kDatabaseName = "couchbase-demo"

// Couchbase Server URL
private let kServerUrl = "http://localhost:4985/default/"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let database: CBLDatabase!
    
    var syncManager : CBLSyncManager!
    
    override init() {
        database = CBLManager.sharedInstance().databaseNamed(kDatabaseName, error: nil)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        if database == nil {
            return false
        }
        
        setupSync()
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: NSString?, annotation: AnyObject) -> Bool {
        return syncManager.handleOpenUrl(url)
    }
    
    func setupSync() {
        syncManager = CBLSyncManager(database: self.database, serverUrl: kServerUrl)
        
        if(syncManager.userIsAuthenticated()) {
            syncManager.start()
        }
    }
    
//    func loginAndSync(complete: () -> ()) {
//        if (syncManager.userIsAuthenticated()) {
//            complete()
//        } else {
////            [_cblSync beforeFirstSync:^(NSString *userID, NSDictionary *userData, NSError **outError) {
////                complete();
////            }];
//        }
//    }
    
//    func applicationWillResignActive(application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    }
//
//    func applicationDidEnterBackground(application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//
//    func applicationWillEnterForeground(application: UIApplication) {
//        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    }
//
//    func applicationDidBecomeActive(application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//
//    func applicationWillTerminate(application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }
    
}

