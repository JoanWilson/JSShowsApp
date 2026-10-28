//
//  SceneDelegate.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 16/04/25.
//

import UIKit
import ShowsList

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene: UIWindowScene = (scene as? UIWindowScene) else { return }
        let window: UIWindow = UIWindow(windowScene: windowScene)
        let viewController: UIViewController = ShowsListViewController()
        let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
