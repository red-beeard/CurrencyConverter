//
//  ConverterScreenRouter.swift
//  CurrencyConverter
//
//  Created by Red Beard on 24.12.2021.
//

import UIKit

protocol IConverterScreenRouter {
    func goSelect(for key: String)
}

final class ConverterScreenRouter: IConverterScreenRouter {
    
    var controller: UIViewController?
    
    func goSelect(for key: String) {
        let controller = SelectCurrencyScreenAssembly.build(for: key)
        self.controller?.present(controller, animated: true)
    }
    
}
