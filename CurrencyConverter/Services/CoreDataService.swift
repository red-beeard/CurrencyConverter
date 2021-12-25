//
//  CoreDataService.swift
//  CurrencyConverter
//
//  Created by Red Beard on 25.12.2021.
//

import CoreData

protocol ICoreDataUpdateData {
    func updateFromNetwork(currencies: SupportedCurrencies) throws
    func updateFromNetwork(rates: LatestExchangeRates) throws
    func needToUploadIcons() throws -> [CurrencyToLoadImage]
    func updateImageFor(currency: CurrencyToLoadImage) throws
}

protocol ICoreDataGetData {
    func getAvailableCurrencies() throws -> [CurrencyDTO]
}

typealias ICoreDataService = ICoreDataUpdateData & ICoreDataGetData

final class CoreDataService {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurrencyModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//MARK: Functions for update data
extension CoreDataService: ICoreDataUpdateData {
    
    func updateFromNetwork(currencies: SupportedCurrencies) throws {
        let context = persistentContainer.newBackgroundContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Currency", in: context) else { return }
        let fetchRequest = Currency.fetchRequest()
        
        var newCurrencies = currencies
        let oldCurrencies = try context.fetch(fetchRequest)
        
        for oldCurrency in oldCurrencies {
            if let index = newCurrencies.firstIndex(where: { $0.currencyCode == oldCurrency.currencyCode}) {
                oldCurrency.setValues(from: newCurrencies[index])
                newCurrencies.remove(at: index)
            } else {
                persistentContainer.viewContext.delete(oldCurrency)
            }
        }
        
        for newCurrency in newCurrencies {
            let newCurrencyEntity = Currency(entity: entity, insertInto: persistentContainer.viewContext)
            newCurrencyEntity.setValues(from: newCurrency)
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func updateFromNetwork(rates: LatestExchangeRates) throws {
        let fetchRequest = Currency.fetchRequest()
        let context = persistentContainer.newBackgroundContext()
        let currencies = try context.fetch(fetchRequest)
        
        for (currencyCode, rate) in rates.rates {
            if let currency = currencies.first(where: { $0.currencyCode == currencyCode }) {
                currency.setValues(rate: rate, date: rates.date)
            }
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func needToUploadIcons() throws -> [CurrencyToLoadImage] {
        let context = persistentContainer.newBackgroundContext()
        let fetchRequest = Currency.fetchRequest()
        let currencies = try context.fetch(fetchRequest)
        
        let result = currencies.compactMap { currency -> CurrencyToLoadImage? in
            if currency.icon == nil {
                return CurrencyToLoadImage(from: currency)
            }
            return nil
        }
        
        return result
    }
    
    func updateImageFor(currency: CurrencyToLoadImage) throws {
        let fetchRequest = Currency.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "currencyCode = %@", currency.currencyCode)
        
        let context = persistentContainer.newBackgroundContext()
        let currencies = try context.fetch(fetchRequest)
        
        if let oldCurrency = currencies.first {
            oldCurrency.icon = currency.imageData
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

//MARK: ICoreDataGetData
extension CoreDataService: ICoreDataGetData {
    
    func getAvailableCurrencies() throws -> [CurrencyDTO] {
        let fetchRequest = Currency.fetchRequest()
        let currencies = try persistentContainer.viewContext.fetch(fetchRequest)
        
        let availableCurrencies = currencies.filter { $0.status == StatusCurrency.available.rawValue }
        
        return availableCurrencies.compactMap { CurrencyDTO(currency: $0) }
    }
    
}
