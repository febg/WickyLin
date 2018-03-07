//
//  AppDelegate.swift
//  Lin
//
//  Created by Xinyi Zhuang on 02/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    window?.rootViewController = Storyboard.Main.initialViewController
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    Analytics.logEvent("applicationWillResignActive", parameters: logInfo)
  }
  func applicationDidBecomeActive(_ application: UIApplication) {
    Analytics.logEvent("applicationDidBecomeActive", parameters: logInfo)
  }
  func applicationDidEnterBackground(_ application: UIApplication) {
    Analytics.logEvent("applicationDidEnterBackground", parameters: logInfo)
  }
  func applicationWillEnterForeground(_ application: UIApplication) {
    Analytics.logEvent("applicationWillEnterForeground", parameters: logInfo)
  }

  var logInfo: [String: UIViewController]? {
    guard let topVc = UIApplication.topViewController() else { return nil}
    return ["topViewController": topVc]
  }
}

extension UIApplication {
  class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
      return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return topViewController(controller: selected)
      }
    }
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    return controller
  }
}
