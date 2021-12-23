//
//  NetworkService.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import Foundation

protocol INetworkService {
    
}

final class NetworkService {
    
    private enum EndPoints: String {
        case supportedCurrencies = "/supported-currencies"
    }
    
    private let session = URLSession(configuration: .default)
    private let apiURL = "https://api.currencyfreaks.com"
    
    func loadSupportedCurrencies() {
        guard let url = URL(string: apiURL + EndPoints.supportedCurrencies.rawValue) else { return }
        
        let request = URLRequest(url: url)
        self.session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }

            print(String(data: data, encoding: .utf8) ?? "nil")
        }
    }
}
