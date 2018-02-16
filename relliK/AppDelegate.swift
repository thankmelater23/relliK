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
import BuddyBuildSDK
import SwiftyBeaver
import CoreData
//import Fabric
//import Crashlytics
import Siren
//import GoogleMobileAds
//import Flurry_iOS_SDK
//import Amplitude_iOS
//import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    self.setup()
    
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
  
  func printAppInfo() {
    
    //        let CFBundleShortVersionString = Siren. //AppInfo.CFBundleShortVersionString
    //        let Copyright = AppInfo.Copyright
    //        let docs = AppInfo.docs
    //        let ID = AppInfo.ID
    //        let fdr = AppInfo.
    
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      log.verbose("Version Running: \(version)")
    }
    if let CFBundleDevelopmentRegion = Bundle.main.infoDictionary?["CFBundleDevelopmentRegion"] as? String {
      log.verbose("Version Running: \(CFBundleDevelopmentRegion)")
    }
    if let CFBundleDisplayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
      log.verbose("Version Running: \(CFBundleDisplayName)")
    }
    if let CFBundleDocumentTypes = Bundle.main.infoDictionary?["CFBundleDocumentTypes"] as? String {
      log.verbose("Version Running: \(CFBundleDocumentTypes)")
    }
    if let CFBundleExecutable = Bundle.main.infoDictionary?["CFBundleDeCFBundleExecutablevelopmentRegion"] as? String {
      log.verbose("Version Running: \(CFBundleExecutable)")
    }
    if let CFBundleIconFile = Bundle.main.infoDictionary?["CFBundleIconFile"] as? String {
      log.verbose("Version Running: \(CFBundleIconFile)")
    }
    if let CFBundleIcons = Bundle.main.infoDictionary?["CFBundleIcons"] as? String {
      log.verbose("Version Running: \(CFBundleIcons)")
    }
    if let CFBundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String {
      log.verbose("Version Running: \(CFBundleIdentifier)")
    }
    if let CFBundleLocalizations = Bundle.main.infoDictionary?["CFBundleLocalizations"] as? String {
      log.verbose("Version Running: \(CFBundleLocalizations)")
    }
    if let CFBundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
      log.verbose("Version Running: \(CFBundleName)")
    }
    if let CFBundlePackageType = Bundle.main.infoDictionary?["CFBundlePackageType"] as? String {
      log.verbose("Version Running: \(CFBundlePackageType)")
    }
    if let CFBundleShortVersionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      log.verbose("Version Running: \(CFBundleShortVersionString)")
    }
    if let CFBundleSignature = Bundle.main.infoDictionary?["CFBundleSignature"] as? String {
      log.verbose("Version Running: \(CFBundleSignature)")
    }
    if let CFBundleSpokenName = Bundle.main.infoDictionary?["CFBundleSpokenName"] as? String {
      log.verbose("Version Running: \(CFBundleSpokenName)")
    }
    if let CFBundleURLTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? String {
      log.verbose("Version Running: \(CFBundleURLTypes)")
    }
    if let CFBundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
      log.verbose("Version Running: \(CFBundleVersion)")
    }
    if let CFBundleTypeName = Bundle.main.infoDictionary?["CFBundleTypeName"] as? String {
      log.verbose("Version Running: \(CFBundleTypeName)")
    }
    if let LSHandlerRank = Bundle.main.infoDictionary?["LSHandlerRank"] as? String {
      log.verbose("Version Running: \(LSHandlerRank)")
    }
    if let CFBundlePackageType = Bundle.main.infoDictionary?["CFBundlePackageType"] as? String {
      log.verbose("Version Running: \(CFBundlePackageType)")
    }
  }
  
  // MARK: - Setup
  ///Run initial configuration functions
  // MARK: - Configuration
  /// Where all developer sysem setup happens
  func setup() {
    GlobalUtilityQueue.async {[weak self] in
      //  self.removeConstraintFromLogger()
      self?.swiftBeaverSetUp()
      self?.sirenConfiguration()
      self?.printAppInfo()
      self?.buddyBuildConfig()
      //  self.googleAdConfig()
      //  self.fireBaseConfig()
      //  self.firebaseDatabaseConfig()
      //  self.furryAnalyticsConfig()
      //  self.amplitudeAnalyticsConfig()
      //  self.facebookAnalyticsConfig()
      self?.fabricSetUp()
    }
  }
  // MARK: - 3rd Party Integration
  /** Swifty Beaver logger configuration
   
   -  Note: Logger
   */
  func swiftBeaverSetUp() {
    log.verbose(#function)
    let console = ConsoleDestination()
    log.addDestination(console)
    let file = FileDestination()
    log.addDestination(file)
    log.verbose("Verbose Test") // prio 1, VERBOSE in silver
    log.debug("Debug Test") // prio 2, DEBUG in blue
    log.info("Info Test") // prio 3, INFO in green
    log.warning("Warning Test") // prio 4, WARNING in yellow
    log.error("Error Test") // prio 5, ERROR in red
    let platform = SBPlatformDestination(appID: PrivateKeys.swiftBeaverAppid, appSecret: PrivateKeys.swiftBeaverSecret, encryptionKey: PrivateKeys.swiftBeaverEncryptionKey)
    log.addDestination(platform)
  }
  // MARK: - Analytics
  /** Fabric Configuration
   
   -  Note: Fabric Services: Analytics, Crash Reporting, Fastlane, and more
   */
  func fabricSetUp() {
    log.verbose(#function)
    GlobalMainQueue.async {
      Fabric.with([Crashlytics.self, Answers.self]) // Appsee.self
    }
    Fabric.sharedSDK().debug = true
    Answers.logContentView(withName: "Fabric Setup", contentType: "Activation", contentId: "relliK", customAttributes: nil)
  }
  func buddyBuildConfig() {
    GlobalMainQueue.async {[weak self] in
      BuddyBuildSDK.setup()
    }
  }
  func fabricConfiguration() {
    GlobalMainQueue.async {[weak self] in
      Fabric.with([Crashlytics.self(), Answers.self()])
    }
  }
  func sirenConfiguration() {
    log.verbose(#function)
    /* Siren code should go below window?.makeKeyAndVisible() */
    
    // Siren is a singleton
    let siren = Siren.shared
    
    // Required: Your app's iTunes App Store ID
    //        siren.appID = "1300481560"
    
    // Optional: Defaults to .Option
    
    /*
     Replace .Immediately with .Daily or .Weekly to specify a maximum daily or weekly frequency for version
     checks.
     */
    siren.checkVersion(checkType: .daily)
    
    siren.alertType = .skip // SirenAlertType.option
    
    siren.showAlertAfterCurrentVersionHasBeenReleasedForDays = 1
  }
}
