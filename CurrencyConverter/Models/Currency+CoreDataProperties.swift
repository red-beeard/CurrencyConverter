//
//  Currency+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Red Beard on 25.12.2021.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var currencyCode: String
    @NSManaged public var currencyName: String
    @NSManaged public var iconURL: URL
    @NSManaged public var status: String
    @NSManaged public var countryName: String
    @NSManaged public var countryCode: String
    @NSManaged public var dateUpdated: Date?
    @NSManaged public var exchangeRate: NSNumber?
    @NSManaged public var icon: Data?

}

extension Currency : Identifiable {

}

extension Currency {
    
    func setValues(from currency: SupportedCurrencyDTO) {
        self.currencyCode = currency.currencyCode
        self.currencyName = currency.currencyName
        self.iconURL = currency.iconURL
        self.status = currency.status.rawValue
        self.countryCode = currency.countryCode
        self.countryName = currency.countryName
    }
    
    func setValues(rate: Double, date: Date) {
        self.exchangeRate = NSNumber(floatLiteral: rate)
        self.dateUpdated = date
    }
    
}
