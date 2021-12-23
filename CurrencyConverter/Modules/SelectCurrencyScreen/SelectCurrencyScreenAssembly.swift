//
//  SelectCurrencyScreenAssembly.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import UIKit

final class SelectCurrencyScreenAssembly {
    static func build() -> UIViewController {
        let dataManager = DataManager.shared
        let router = SelectCurrencyScreenRouter()
        let presenter = SelectCurrencyScreenPresenter(dataManager: dataManager, router: router)
        
        let controller = SelectCurrencyScreenViewController(presenter: presenter)
        router.controller = controller
        
        return UINavigationController(rootViewController: controller)
    }
}
