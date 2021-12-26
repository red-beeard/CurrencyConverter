//
//  SelectCurrencyScreenPresenter.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import Foundation

protocol ISelectCurrencyScreenPresenter {
    func loadView(controller: ISelectCurrencyScreenViewController, view: ISelectCurrencyScreenView)
    func filteredCurrencies(_ text: String?)
}

final class SelectCurrencyScreenPresenter {
    
    private enum Constants {
        static let titleVC = "Select currency"
        static let searchPlaceholder = "Search currency"
    }
    
    private let dataManager: IDataManager
    private let router: ISelectCurrencyScreenRouter
    private let tableAdapter: ISelectCurrencyScreenTableAdapter
    
    private var currencies = [CurrencyDTO]()
    
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
                self.currencies = currencies
                let viewModelCurrencies = currencies.map { SelectCurrencyScreenViewModel($0) }
                DispatchQueue.main.async {
                    self.tableAdapter.update(viewModelCurrencies)
                }
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
        self.controller?.setSearchPlaceholder(Constants.searchPlaceholder)
        
        self.view = view
        self.tableAdapter.tableView = self.view?.getTableView()
        self.loadData()
    }
    
    func filteredCurrencies(_ text: String?) {
        var viewModelCurrencies = self.currencies.map { SelectCurrencyScreenViewModel($0) }
        
        guard let text = text, text.isEmpty == false else {
            self.tableAdapter.update(viewModelCurrencies)
            return
        }

        viewModelCurrencies = viewModelCurrencies.filter { currency in
            currency.currencyName.localizedCaseInsensitiveContains(text) ||
            currency.currencyCode.localizedCaseInsensitiveContains(text)
        }
        
        self.tableAdapter.update(viewModelCurrencies)
    }
    
}
