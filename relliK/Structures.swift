//
//  Structures.swift
//  relliK
//
//  Created by Andre on 1/26/18.
//  Copyright © 2018 Bang Bang Studios. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Settings Keys
/// Keys for userdefaults settings
struct SettingsKeys {
  static let adPurchased = "adPurchased"
  static let firstStart = "firstStart"
  static let lastDateActive = "lastDateActive"
  static let notificationsEnabled = "notificationsEnabled"
  static let daysSinceNotActive = "daysSinceNotActive"
  static let onBoardComplete = "onBoardComplete"
}

struct imagesString{
  static let player = "player arms-out"
  static let Boss = "marshmello"
  static let enemy1 = "zombie1"
  static let enemy2 = "enemy"
  static let enemy3 = "cartoon-zombie"
  static let engine = "engine"
  static let rainDrop = "rainDrop"
}

enum GameState{
  case mainMenu, loading, playing, gameOver, paused
}


// MARK: - Private Keys
/// Private keys for 3rd party system integrations
struct PrivateKeys {
  static let fireBaseAnalytics = ""
  static let googleAdAppIdKey = ""
  static let googleAdFakeAppIdKey = ""
  static let oneSignalAppId = ""
  static let swiftBeaverAppid = "E9QGO2"
  static let swiftBeaverSecret = "1wymhngm6lnxe06v0MowepqdzmAfhdiq"
  static let swiftBeaverEncryptionKey = "svgve2ypf4TgkJ0pasizcqIJ5gNtsyhP"
  static let furryAppID = ""
  static let amplitudeProjectID = ""
  static let furryWatchAppID = ""
  static let amplitudeAPIKey = ""
  static let amplitudeSecretKey = ""
  static let facebookAnalyticsAppID = ""
  static let facebookAnalyticsAppSecret = ""
  static let facebookAnalyticsClientToken = ""
  static let appAnalyticsAPIKey = " "
}

// MARK: - Colors
// App colors
struct Colors {
  static let a = UIColor(named: "")
  static let b = UIColor(named: "")
  static let c = UIColor(named: "")
  static let d = UIColor(named: "")
  static let e = UIColor(named: "")
  static let f = UIColor(named: "")
}

// MARK: - Day Of Week
// Day Of The Week enum that returns day of week abriviated
enum DayOfTheWeek: String {
  case Mon, Tue, Wed, Thur, Fri, Sat, Sun, Na
  /// Returns: Abreviation string of current day of the week
  mutating func returnShrtDayOfTheWeek() -> String! {
    switch self {
    case .Mon:
      return "M"
      
    case .Tue:
      return "T"
      
    case .Wed:
      return "W"
      
    case .Thur:
      return "TH"
      
    case .Fri:
      return "F"
      
    case .Sat:
      return "S"
      
    case .Sun:
      return "SU"
    case .Na:
      return "-"
    }
  }
}


// MARK: - Cell Identifiers
/// Tableview Cells Identifiers
struct CellIdentifier {
  static let a = ""
  static let b = ""
  static let c = ""
  static let d = ""
}

// MARK: - Segues
/// Segue keys
struct Segue {
  // ViewController
  static let Segue_To_a = ""
  static let Segue_To_b = ""
  static let Segue_To_c = ""
  static let Segue_To_d = ""
  static let Segue_To_e = ""
  
  // Global
  static let Unwind_To_ = "UnwindTo"
}

// MARK: - Constants
/// Constants
struct Constants {
  static let a = 0
}

// MARK: - Images
/// Common app images
struct Images {
  static let image = UIImage(named: "")
}
