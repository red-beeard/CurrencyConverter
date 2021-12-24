//
//  SupportedCurrencyDTO.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

import Foundation

typealias SupportedCurrenciesDTO = [SupportedCurrencyDTO]

enum StatusDTO: String, Decodable {
    case available = "available"
    case notAvailable = "not_available"
}

struct SupportedCurrencyDTO: Decodable {
    let currencyCode, currencyName: String
    let status: StatusDTO
    let countryCode, countryName: String
    let iconURL: String

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
        self.status = try container.decode(StatusDTO.self, forKey: .status)
        self.countryCode = try container.decode(String.self, forKey: .countryCode)
        self.countryName = try container.decode(String.self, forKey: .countryName)
        self.iconURL = try container.decode(String.self, forKey: .icon)
    }

}
