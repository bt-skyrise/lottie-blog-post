//
//  AppDelegate.swift
//  LottieSkyriseLoaderExample
//
//  Created by Kamil Chlebuś on 02/01/2019.
//  Copyright © 2019 Skyrise. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AnimationViewController()
        window?.makeKeyAndVisible()
        return true
    }

}

