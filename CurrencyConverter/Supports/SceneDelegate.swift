//
//  SceneDelegate.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        self.window?.rootViewController = SelectCurrencyScreenAssembly.build()
//        self.window?.rootViewController = ConverterScreenAssembly.build()
        self.window?.makeKeyAndVisible()
    }

}

