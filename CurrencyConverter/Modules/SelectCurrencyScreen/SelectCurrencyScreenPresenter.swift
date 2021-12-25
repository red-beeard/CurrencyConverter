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
    
    private enum Constants {
        static let titleVC = "Select currency"
    }
    
    private let dataManager: IDataManager
    private let router: ISelectCurrencyScreenRouter
    private let tableAdapter: ISelectCurrencyScreenTableAdapter
    
    private weak var controller: ISelectCurrencyScreenViewController?
    private weak var view: ISelectCurrencyScreenView?
    
    init(dataManager: IDataManager, router: ISelectCurrencyScreenRouter, tableAdapter: ISelectCurrencyScreenTableAdapter) {
        self.dataManager = dataManager
        self.router = router
        self.tableAdapter = tableAdapter
    }
    
    private func loadData() {
        self.dataManager.loadAvailableCurrenciesWithRate { result in
            switch result {
            case .success(let currencies):
                let viewModelCurrencies = currencies.map { SelectCurrencyScreenViewModel($0) }
                self.tableAdapter.update(viewModelCurrencies)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension SelectCurrencyScreenPresenter: ISelectCurrencyScreenPresenter {
    
    func loadView(controller: ISelectCurrencyScreenViewController, view: ISelectCurrencyScreenView) {
        self.controller = controller
        self.controller?.setTitle(Constants.titleVC)
        
        self.view = view
        self.tableAdapter.tableView = self.view?.getTableView()
        self.loadData()
    }
    
}
