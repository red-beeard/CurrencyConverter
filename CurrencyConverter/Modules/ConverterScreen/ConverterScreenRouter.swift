//
//  ConverterScreenRouter.swift
//  CurrencyConverter
//
//  Created by Red Beard on 24.12.2021.
//

import UIKit

protocol IConverterScreenRouter {
    func goSelect(with notification: String)
}

final class ConverterScreenRouter: IConverterScreenRouter {
    
    var controller: UIViewController?
    
    func goSelect(with notification: String) {
        let controller = SelectCurrencyScreenAssembly.build()
        self.controller?.present(controller, animated: true)
    }
    
}
