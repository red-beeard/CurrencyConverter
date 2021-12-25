//
//  SupportedCurrency.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import Foundation

typealias SupportedCurrencies = [SupportedCurrency]

enum StatusCurrency: String, Decodable {
    case available = "available"
    case notAvailable = "not_available"
}

struct SupportedCurrency: Decodable {
    let currencyCode, currencyName: String
    let status: StatusCurrency
    let countryCode, countryName: String
    let iconURL: URL

    private enum CodingKeys: String, CodingKey {
        case currencyCode, currencyName
        case status
        case countryCode, countryName
        case icon
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.currencyCode = try container.decode(String.self, forKey: .currencyCode)
        self.currencyName = try container.decode(String.self, forKey: .currencyName)
        self.status = try container.decode(StatusCurrency.self, forKey: .status)
        self.countryCode = try container.decode(String.self, forKey: .countryCode)
        self.countryName = try container.decode(String.self, forKey: .countryName)
        self.iconURL = try container.decode(URL.self, forKey: .icon)
    }

}
