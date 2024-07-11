//
//  SceneDelegate.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var applicationCoordinator: Coordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        applicationCoordinator = AppCoordinator(navigationController: navigationController)
        applicationCoordinator?.startFlow()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

