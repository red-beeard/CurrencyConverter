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
        static let titleVC = "Currency converter"
    }
    
    private let dataManager: IDataManager
    private let router: IConverterScreenRouter
    private weak var controller: IConverterScreenViewController?
    private weak var view: IConverterScreenView?
    
    init(dataManager: IDataManager, router: IConverterScreenRouter) {
        self.dataManager = dataManager
        self.router = router
    }
    
}

extension ConverterScreenPresenter: IConverterScreenPresenter {
    
    func loadView(controller: IConverterScreenViewController, view: IConverterScreenView) {
        self.controller = controller
        self.controller?.setTitle(Constants.titleVC)
        
        self.view = view
    }
    
}