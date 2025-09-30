//
//  SceneDelegate.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 23.09.2025.
//

import UIKit
import DITranquillity

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var alertWindow: UIWindow?
    let container = DIContainer()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        ApplicationDependency.load(container: container)
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        let navController = UINavigationController()
        let assembly: ICharacterListAssembly = container.resolve()
        navController.viewControllers = [assembly.assembly()]
        window?.rootViewController = navController
        
        let alertWindow = UIWindow(windowScene: scene)
        alertWindow.makeKeyAndVisible()
        alertWindow.windowLevel = .alert + 1
        alertWindow.isHidden = true
        self.alertWindow = alertWindow
    }
}

