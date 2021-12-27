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
    private let keyForSelect: String
    
    private var currencies = [CurrencyDTO]()
    
    private weak var controller: ISelectCurrencyScreenViewController?
    private weak var view: ISelectCurrencyScreenView?
    
    init(keyForSelect: String, dataManager: IDataManager, router: ISelectCurrencyScreenRouter, tableAdapter: ISelectCurrencyScreenTableAdapter) {
        self.keyForSelect = keyForSelect
        self.dataManager = dataManager
        self.router = router
        self.tableAdapter = tableAdapter
    }
    
    deinit {
        print("SelectCurrencyScreenPresenter deinit")
    }
    
    private func loadData() {
        self.dataManager.loadAvailableCurrenciesWithRate { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.currencies = currencies
                
                if let viewModelCurrencies = self?.getViewModelCurrencies(from: currencies) {
                    DispatchQueue.main.async {
                        self?.tableAdapter.update(viewModelCurrencies)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setHandlers() {
        self.controller?.cancelButtonTappedHandler = { [weak self] in
            self?.router.goBack()
        }
    }
    
    private func getViewModelCurrencies(from currencies: [CurrencyDTO]) -> TableViewData {
        currencies.reduce(into: TableViewData()) { partialResult, currency in
            let currencyViewModel = SelectCurrencyScreenViewModel(currency)
            
            var section: SectionIdenfier
            switch currency.countryCode {
            case SectionIdenfier.crypro.rawValue: section = SectionIdenfier.crypro
            case SectionIdenfier.metal.rawValue: section = SectionIdenfier.metal
            default: section = SectionIdenfier.country
            }
            
            if partialResult[section] != nil {
                partialResult[section]?.append(currencyViewModel)
            } else {
                partialResult[section] = [currencyViewModel]
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
        self.tableAdapter.delegate = self
        
        self.loadData()
        self.setHandlers()
    }
    
    func filteredCurrencies(_ text: String?) {
        var viewModelCurrencies = self.getViewModelCurrencies(from: self.currencies)
        
        guard let text = text, text.isEmpty == false else {
            self.tableAdapter.update(viewModelCurrencies)
            return
        }
        
        for (section, currencies) in viewModelCurrencies {
            viewModelCurrencies[section] = currencies.filter { currency in
                currency.currencyName.localizedCaseInsensitiveContains(text) ||
                currency.currencyCode.localizedCaseInsensitiveContains(text)
            }
        }
        
        self.tableAdapter.update(viewModelCurrencies)
    }
    
}

extension SelectCurrencyScreenPresenter: SelectCurrencyScreenTableAdapterDelegate {
    
    func onItemSelect(currencyCode: String) {
        self.dataManager.getCurrency(with: currencyCode) { [weak self] result in
            switch result {
            case .success(let currency):
                if let currency = currency, let key = self?.keyForSelect {
                    let currencyData = try? JSONEncoder().encode(currency)
                    UserDefaults.standard.set(currencyData, forKey: key)
                    
                    DispatchQueue.main.async {
                        self?.router.goBack()
                    }
                }
            case .failure(let error):
                self?.controller?.showAlert(title: "Error😔", message: error.localizedDescription)
            }
        }
    }
    
}
