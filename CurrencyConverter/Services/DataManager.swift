//
//  DataManager.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import Foundation

protocol IDataManager {
    
}

final class DataManager {
    
    static let shared = DataManager()
    
    private let networkService: INetworkService = NetworkService()
    private let coreDataService: ICoreDataService = CoreDataService()
    
    private init() {
        self.initiaDataLoading()
    }
    
    private func initiaDataLoading() {
        DispatchQueue.global(qos: .userInitiated).async {
            let group = DispatchGroup()
            
            group.enter()
            self.networkService.loadSupportedCurrencies { result in
                switch result {
                case .success(let supportedCurrencies):
                    try? self.coreDataService.updateFromNetwork(currencies: supportedCurrencies)
                    print("supportedCurrencies")
                case .failure(let error):
                    print(error)
                }
                group.leave()
            }
            
            group.wait()
            self.networkService.loadExchangeRates { result in
                switch result {
                case .success(let exchangeRates):
                    try? self.coreDataService.updateFromNetwork(rates: exchangeRates)
                    print("exchangeRates")
                case .failure(let error):
                    print(error)
                }
            }
            
            if let currencies = try? self.coreDataService.needToUploadIcons() {
                for currency in currencies {
                    self.networkService.loadImage(currency: currency) { currency, result in
                        switch result {
                        case .success(let data):
                            var newCurrency = currency
                            newCurrency.imageData = data
                            
                            try? self.coreDataService.updateImageFor(currency: newCurrency)
                            print("updateImageFor \(newCurrency.currencyCode)")
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
            
        }
    }
    
}

extension DataManager: IDataManager {
    
    func loadSupportedCurrencies(completion: @escaping (Result<SupportedCurrenciesDTO, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
//            self.coreDataService.loadSupportedCurrencies(completion: completion)
            self.networkService.loadSupportedCurrencies(completion: completion)
        }
    }
    
    func loadExchangeRates(completion: @escaping (Result<LatestExchangeRatesDTO, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.networkService.loadExchangeRates(completion: completion)
        }
    }
    
}
