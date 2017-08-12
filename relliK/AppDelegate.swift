//
//  AppDelegate.swift
//  relliK
//
//  Created by Andre Villanueva on 7/25/15.
//  Copyright © 2015 Bang Bang Studios. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self()])
        self.printAppInfo()

        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func printAppInfo(){

        //        let CFBundleShortVersionString = Siren. //AppInfo.CFBundleShortVersionString
        //        let Copyright = AppInfo.Copyright
        //        let docs = AppInfo.docs
        //        let ID = AppInfo.ID
        //        let fdr = AppInfo.
        
        
        
        

        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            print("Version Running: \(version)")
        }
        if let CFBundleDevelopmentRegion = Bundle.main.infoDictionary?["CFBundleDevelopmentRegion"] as? String {
            print("Version Running: \(CFBundleDevelopmentRegion)")
        }
        if let CFBundleDisplayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            print("Version Running: \(CFBundleDisplayName)")
        }
        if let CFBundleDocumentTypes = Bundle.main.infoDictionary?["CFBundleDocumentTypes"] as? String {
            print("Version Running: \(CFBundleDocumentTypes)")
        }
        if let CFBundleExecutable = Bundle.main.infoDictionary?["CFBundleDeCFBundleExecutablevelopmentRegion"] as? String {
            print("Version Running: \(CFBundleExecutable)")
        }
        if let CFBundleIconFile = Bundle.main.infoDictionary?["CFBundleIconFile"] as? String {
            print("Version Running: \(CFBundleIconFile)")
        }
        if let CFBundleIcons = Bundle.main.infoDictionary?["CFBundleIcons"] as? String {
            print("Version Running: \(CFBundleIcons)")
        }
        if let CFBundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String {
            print("Version Running: \(CFBundleIdentifier)")
        }
        if let CFBundleLocalizations = Bundle.main.infoDictionary?["CFBundleLocalizations"] as? String {
            print("Version Running: \(CFBundleLocalizations)")
        }
        if let CFBundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            print("Version Running: \(CFBundleName)")
        }
        if let CFBundlePackageType = Bundle.main.infoDictionary?["CFBundlePackageType"] as? String {
            print("Version Running: \(CFBundlePackageType)")
        }
        
        if let CFBundleShortVersionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            print("Version Running: \(CFBundleShortVersionString)")
        }
        if let CFBundleSignature = Bundle.main.infoDictionary?["CFBundleSignature"] as? String {
            print("Version Running: \(CFBundleSignature)")
        }
        if let CFBundleSpokenName = Bundle.main.infoDictionary?["CFBundleSpokenName"] as? String {
            print("Version Running: \(CFBundleSpokenName)")
        }
        if let CFBundleURLTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? String {
            print("Version Running: \(CFBundleURLTypes)")
        }
        if let CFBundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            print("Version Running: \(CFBundleVersion)")
        }
        if let CFBundleTypeName = Bundle.main.infoDictionary?["CFBundleTypeName"] as? String {
            print("Version Running: \(CFBundleTypeName)")
        }
        if let LSHandlerRank = Bundle.main.infoDictionary?["LSHandlerRank"] as? String {
            print("Version Running: \(LSHandlerRank)")
        }
        if let CFBundlePackageType = Bundle.main.infoDictionary?["CFBundlePackageType"] as? String {
            print("Version Running: \(CFBundlePackageType)")
        }
    }
}

