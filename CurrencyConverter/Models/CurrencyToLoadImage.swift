//
//  CurrencyToLoadImage.swift
//  CurrencyConverter
//
//  Created by Red Beard on 25.12.2021.
//

import Foundation

struct CurrencyToLoadImage {
    let currencyCode: String
    let iconURL: URL
    var imageData: Data?
    
    init(from currency: Currency) {
        self.currencyCode = currency.currencyCode
        self.iconURL = currency.iconURL
        self.imageData = currency.icon
    }
}
