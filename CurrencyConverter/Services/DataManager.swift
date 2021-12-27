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
        self.initialSetting()
    }
    
}

//MARK: Method for update data
private extension DataManager {
    
    private func initialSetting() {
        DispatchQueue.global(qos: .userInitiated).async {
            let group = DispatchGroup()
            self.updateData(group: group)
            group.wait()
            
            let firstCurrencyData = UserDefaults.standard.data(forKey: PositionCurrencies.first.rawValue)
            let secondCurrencyData = UserDefaults.standard.data(forKey: PositionCurrencies.second.rawValue)
            if firstCurrencyData == nil && secondCurrencyData == nil {
                self.setDefaultCurrencies()
            }
        }
    }
    
    func updateData(group: DispatchGroup = DispatchGroup()) {
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
    
    func setDefaultCurrencies() {
        let currencies = try? self.coreDataService.getDefaultCurrencies()
        
        guard let first = currencies?.0, let firstData = try? JSONEncoder().encode(first) else { return }
        guard let second = currencies?.1, let secondData = try? JSONEncoder().encode(second) else { return }
        
        UserDefaults.standard.set(firstData, forKey: PositionCurrencies.first.rawValue)
        UserDefaults.standard.set(secondData, forKey: PositionCurrencies.second.rawValue)
    }
    
}

//MARK: Method for loads
private extension DataManager {
    
    func loadSupportedCurrencies(group: DispatchGroup) {
        self.networkService.loadSupportedCurrencies { result in
            switch result {
            case .success(let supportedCurrencies):
                try? self.coreDataService.updateFromNetwork(currencies: supportedCurrencies)
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
    }
    
    func loadExchangeRates(group: DispatchGroup) {
        self.networkService.loadExchangeRates { result in
            switch result {
            case .success(let exchangeRates):
                try? self.coreDataService.updateFromNetwork(rates: exchangeRates)
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
    }
    
    func loadImages(group: DispatchGroup) {
        if let currencies = try? self.coreDataService.needToUploadIcons() {
            for currency in currencies {
                group.enter()
                self.networkService.loadImage(currency: currency) { currency, result in
                    switch result {
                    case .success(let data):
                        var newCurrency = currency
                        newCurrency.imageData = data
                        
                        try? self.coreDataService.updateImageFor(currency: newCurrency)
                    case .failure(let error):
                        print(error)
                    }
                    group.leave()
                }
            }
        }
        group.leave()
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
