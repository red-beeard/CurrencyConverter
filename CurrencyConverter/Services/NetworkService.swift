//
//  NetworkService.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import Foundation

protocol INetworkService {
    func loadSupportedCurrencies()
}

final class NetworkService {
    
    private enum EndPoints: String {
        case supportedCurrencies = "/supported-currencies"
    }
    
    private let session = URLSession(configuration: .default)
    private let apiURL = "https://api.currencyfreaks.com"
    
    private func printData(_ data: Data) {
        print(String(decoding: data, as: UTF8.self))
    }
    
    private func dataToUTF8(_ data: Data?) -> Data? {
        guard let data = data else {
            return nil
        }
        
        let dataInString = String(decoding: data, as: UTF8.self)
        return dataInString.data(using: .utf8)
    }
}

extension NetworkService: INetworkService {
    
    func loadSupportedCurrencies() {
        guard let url = URL(string: apiURL + EndPoints.supportedCurrencies.rawValue) else { return }
        
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            }
            
            if let data =  self.dataToUTF8(data) {
                do {
                    let supportedCurrencies = try JSONDecoder().decode(SupportedCurrenciesDTO.self, from: data)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
}
