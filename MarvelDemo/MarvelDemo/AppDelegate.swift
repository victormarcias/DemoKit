//
//  AppDelegate.swift
//  DemoKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        let rootVC = MarvelDemoViewController()
        window?.rootViewController = UINavigationController(rootViewController: rootVC)
        
        return true
    }
}

extension UIColor {
    struct marvel {
        static let red = UIColor(red: 0.77, green: 0.21, blue: 0.20, alpha: 1.0)
        static let black = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        static let gray = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
    }
}
