//
//  ConverterScreenPresenter.swift
//  CurrencyConverter
//
//  Created by Red Beard on 24.12.2021.
//

protocol IConverterScreenPresenter {
    func loadView(controller: IConverterScreenViewController, view: IConverterScreenView)
}

final class ConverterScreenPresenter {
    
    private enum Constants {
        static let titleVC = "Converter"
    }
    
    private let dataManager: IDataManager
    private let router: IConverterScreenRouter
    private weak var controller: IConverterScreenViewController?
    private weak var view: IConverterScreenView?
    
    init(dataManager: IDataManager, router: IConverterScreenRouter) {
        self.dataManager = dataManager
        self.router = router
    }
    
    private func setHandlers() {
        self.view?.firstSelectCurrencyTappedHandler = { [weak self] in
            self?.router.goSelect(with: "firstCurrencyIsChange")
        }
        
        self.view?.secondSelectCurrencyTappedHandler =  { [weak self] in
            self?.router.goSelect(with: "secondCurrencyIsChange")
        }
    }
    
}

extension ConverterScreenPresenter: IConverterScreenPresenter {
    
    func loadView(controller: IConverterScreenViewController, view: IConverterScreenView) {
        self.controller = controller
        self.controller?.setTitle(Constants.titleVC)
        
        self.view = view
        self.setHandlers()
    }
    
}
