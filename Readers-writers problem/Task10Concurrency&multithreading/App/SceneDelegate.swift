//
//  SceneDelegate.swift
//  Task10Concurrency&multithreading
//
//  Created by Tymofii (Work) on 19.10.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let navigation = UINavigationController()
        navigation.viewControllers = [TableViewController()]
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        self.window = window
    }
}

