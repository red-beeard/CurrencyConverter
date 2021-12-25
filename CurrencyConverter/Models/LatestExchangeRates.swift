//
//  LatestExchangeRates.swift
//  CurrencyConverter
//
//  Created by Red Beard on 25.12.2021.
//

import Foundation

struct LatestExchangeRates: Decodable {
    let date: Date
    let base: String
    let rates: [String: Double]
    
    private enum CodingKeys: String, CodingKey {
        case base
        case rates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.date = Date.now
        self.base = try container.decode(String.self, forKey: .base)
        
        let ratesInString = try container.decode([String: String].self, forKey: .rates)
        self.rates = ratesInString.compactMapValues { Double($0) }
    }
}
