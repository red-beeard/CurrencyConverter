//
//  ConverterCurrencyViewModel.swift
//  CurrencyConverter
//
//  Created by Red Beard on 27.12.2021.
//

import Foundation

struct ConverterCurrencyViewModel {
    let currencyCode, currencyName: String
    let image: Data?
    
    init(_ currency: CurrencyDTO) {
        self.currencyCode = currency.currencyCode
        self.currencyName = currency.currencyName
        self.image = currency.image
    }
}
