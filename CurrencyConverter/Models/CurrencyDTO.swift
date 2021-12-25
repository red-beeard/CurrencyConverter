//
//  CurrencyDTO.swift
//  CurrencyConverter
//
//  Created by Red Beard on 25.12.2021.
//

import Foundation

struct CurrencyDTO {
    let currencyCode, currencyName: String
    let countryCode: String
    let image: Data?
    let exchangeRate: Double?
    
    init(currency: Currency) {
        self.currencyCode = currency.currencyCode
        self.currencyName = currency.currencyName
        self.countryCode = currency.countryCode
        self.image = currency.icon
        self.exchangeRate = currency.exchangeRate?.doubleValue
    }
}
