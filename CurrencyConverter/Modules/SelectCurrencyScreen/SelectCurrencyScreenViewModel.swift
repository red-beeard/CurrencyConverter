//
//  SelectCurrencyScreenViewModel.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import Foundation

struct SelectCurrencyScreenViewModel {
    let currencyCode, currencyName: String
    let countryCode: String
    let image: Data?
    
    init(_ currency: CurrencyDTO) {
        self.currencyCode = currency.currencyCode
        self.currencyName = currency.currencyName
        self.countryCode = currency.countryCode
        self.image = currency.image
    }
}

extension SelectCurrencyScreenViewModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.currencyCode)
    }
    
    static func == (lhs: SelectCurrencyScreenViewModel, rhs: SelectCurrencyScreenViewModel) -> Bool {
        lhs.currencyCode == rhs.currencyCode
    }
    
}
