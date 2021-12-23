//
//  SelectCurrencyScreenPresenter.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

protocol ISelectCurrencyScreenPresenter {
    func loadView(controller: ISelectCurrencyScreenViewController, view: ISelectCurrencyScreenView)
}

final class SelectCurrencyScreenPresenter {
    
    private let dataManager: IDataManager
    private let router: ISelectCurrencyScreenRouter
    private weak var controller: ISelectCurrencyScreenViewController?
    private weak var view: ISelectCurrencyScreenView?
    
    init(dataManager: IDataManager, router: ISelectCurrencyScreenRouter) {
        self.dataManager = dataManager
        self.router = router
    }
    
}

extension SelectCurrencyScreenPresenter: ISelectCurrencyScreenPresenter {
    
    func loadView(controller: ISelectCurrencyScreenViewController, view: ISelectCurrencyScreenView) {
        self.controller = controller
        self.view = view
    }
    
}
