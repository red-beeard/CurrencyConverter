//
//  SelectCurrencyScreenRouter.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import UIKit

protocol ISelectCurrencyScreenRouter {
    func goBack()
}

final class SelectCurrencyScreenRouter: ISelectCurrencyScreenRouter {
    
    var controller: UIViewController?
    
    func goBack() {
        self.controller?.dismiss(animated: true)
    }
    
}
