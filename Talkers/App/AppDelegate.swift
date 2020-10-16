//
//  AppDelegate.swift
//  Talkers
//
//  Created by Natalia Kazakova on 11.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  // swiftlint:disable:next line_length
  func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    // swiftlint:disable:next line_length
    Logger.printInLog("Launch process has begun but that state restoration has not yet occurred: \(#function). Initializing the app")
    return true
  }
  
  // swiftlint:disable:next line_length
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Logger.printInLog("Application moved from initialize to launch: \(#function)")
    return true
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    Logger.printInLog("\(#function) called to finish up the transition to the foreground")
  }

  func applicationWillResignActive(_ application: UIApplication) {
    Logger.printInLog("Application moved from launch to inactive: \(#function)")
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    Logger.printInLog("Application moved from inactive to background: \(#function)")
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    Logger.printInLog("Application moved from background to active after interruption: \(#function)")
  }

  func applicationWillTerminate(_ application: UIApplication) {
    Logger.printInLog("\(#function) called when app is about to be purged from memory")
  }
}
