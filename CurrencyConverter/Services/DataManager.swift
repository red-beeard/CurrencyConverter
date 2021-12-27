//
//  DataManager.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import Foundation

protocol IDataManager {
    func loadAvailableCurrenciesWithRate(completion: @escaping (Result<[CurrencyDTO], Error>) -> Void)
    func getCurrency(with currencyCode: String, completion: @escaping (Result<CurrencyDTO?, Error>) -> Void)
}

final class DataManager {
    
    static let shared = DataManager()
    
    private let networkService: INetworkService = NetworkService()
    private let coreDataService: ICoreDataService = CoreDataService()
    
    private init() {
        self.updateData()
    }
    
    private func loadSupportedCurrencies(group: DispatchGroup) {
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
    }
    
    private func loadExchangeRates(group: DispatchGroup) {
        self.networkService.loadExchangeRates { result in
            switch result {
            case .success(let exchangeRates):
                try? self.coreDataService.updateFromNetwork(rates: exchangeRates)
                print("exchangeRates")
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
    }
    
    private func loadImages(group: DispatchGroup) {
        if let currencies = try? self.coreDataService.needToUploadIcons() {
            for currency in currencies {
                group.enter()
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
                    group.leave()
                }
            }
        }
        group.leave()
    }
    
    private func updateData(group: DispatchGroup = DispatchGroup()) {
        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
            self.loadSupportedCurrencies(group: group)
            group.wait()
            group.enter()
            self.loadExchangeRates(group: group)
            group.enter()
            self.loadImages(group: group)
            group.wait()
        }
    }
    
}

extension DataManager: IDataManager {
    
    func loadAvailableCurrenciesWithRate(completion: @escaping (Result<[CurrencyDTO], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let group = DispatchGroup()
                
                var currencies = try self.coreDataService.getAvailableCurrencies()
                completion(.success(currencies))
                
                self.updateData(group: group)
                
                currencies = try self.coreDataService.getAvailableCurrencies()
                completion(.success(currencies))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getCurrency(with currencyCode: String, completion: @escaping (Result<CurrencyDTO?, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let currency = try self.coreDataService.getCurrency(with: currencyCode)
                completion(.success(currency))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}
