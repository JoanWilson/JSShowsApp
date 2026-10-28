//
//  AppDelegate.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 16/04/25.
//

import UIKit
import FirebaseTracking

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("-UITests") {
            URLProtocol.registerClass(TVMazeStubURLProtocol.self)
            return true
        }
        #endif
        FirebaseTracker.start()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
