//
//  ConverterScreenAssembly.swift
//  CurrencyConverter
//
//  Created by Red Beard on 24.12.2021.
//

import UIKit

final class ConverterScreenAssembly {
    static func build() -> UIViewController {
        let dataManager = DataManager.shared
        let router = ConverterScreenRouter()
        let presenter = ConverterScreenPresenter(dataManager: dataManager, router: router)
        
        let controller = ConverterScreenViewController(presenter: presenter)
        router.controller = controller
        
        return UINavigationController(rootViewController: controller)
    }
}
