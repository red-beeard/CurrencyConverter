//
//  NetworkService.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import Foundation

protocol INetworkService {
    func loadSupportedCurrencies(completion: @escaping (Result<SupportedCurrencies, Error>) -> Void)
    func loadExchangeRates(completion: @escaping (Result<LatestExchangeRates, Error>) -> Void)
    func loadImage(currency: CurrencyToLoadImage, completion: @escaping (CurrencyToLoadImage, Result<Data, Error>) -> Void)
}

final class NetworkService {
    
    private enum EndPoints: String {
        case supportedCurrencies = "/supported-currencies"
        case latestExchangeRates = "/latest"
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
    
    private func loadData<T: Decodable>(from endPoint: EndPoints, completion: @escaping (Result<T, Error>) -> Void) {
        var url = URLComponents(string: apiURL + endPoint.rawValue)
        let apiKeyItem = URLQueryItem(name: "apikey", value: "d19b5cc7165e411d973e4660a85556d0")
        url?.queryItems = [apiKeyItem]
        
        guard let url = url?.url else { return }
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            }
            
            if let data =  self.dataToUTF8(data) {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
}

extension NetworkService: INetworkService {
    
    func loadSupportedCurrencies(completion: @escaping (Result<SupportedCurrencies, Error>) -> Void) {
        self.loadData(from: .supportedCurrencies, completion: completion)
    }
    
    func loadExchangeRates(completion: @escaping (Result<LatestExchangeRates, Error>) -> Void) {
        self.loadData(from: .latestExchangeRates, completion: completion)
    }
    
    func loadImage(currency: CurrencyToLoadImage, completion: @escaping (CurrencyToLoadImage, Result<Data, Error>) -> Void) {
        let request = URLRequest(url: currency.iconURL)
        
        self.session.downloadTask(with: request) { url, response, error in
            if let error = error {
                completion(currency, .failure(error))
            }
            
            if let url = url {
                if let result = try? Data(contentsOf: url) {
                    completion(currency, .success(result))
                }
            }
        }.resume()
    }
    
}
