//
//  DataManager.swift
//  CurrencyConverter
//
//  Created by Red Beard on 23.12.2021.
//

protocol IDataManager {
    
}

final class DataManager {
    
    static let shared = DataManager()
    
    private init() { }
    
}

extension DataManager: IDataManager {
    
}
