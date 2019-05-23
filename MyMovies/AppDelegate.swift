//
//  AppDelegate.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 04/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = setupAppWindow(with: LoginViewController() )
        return true
    }

}

// MARK:- Setting Up Window

extension AppDelegate {
    
    func setupAppWindow(with rootViewController: UIViewController) -> UIWindow {
        let window = UIWindow()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        return window
    }
    
    
    
    
}
