//
//  AppDelegate.swift
//  Lin
//
//  Created by Xinyi Zhuang on 02/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window?.rootViewController = Storyboard.Main.initialViewController
    return true
  }
}
