//
//  AppDelegate.swift
//  Talkers
//
//  Created by Natalia Kazakova on 11.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit
import Firebase
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  private let rootAssembly = RootAssembly()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()

    self.window = UIWindow(frame: UIScreen.main.bounds)
    let controller = rootAssembly.presentationAssembly.conversationsListViewController()
    window?.rootViewController = controller
    window?.makeKeyAndVisible()
    
    return true
  }
}
