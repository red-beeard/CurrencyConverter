//
//  CoreDataService.swift
//  CurrencyConverter
//
//  Created by Red Beard on 25.12.2021.
//

import CoreData

protocol ICoreDataService {
    func updateFromNetwork(currencies: SupportedCurrenciesDTO) throws
    func updateFromNetwork(rates: LatestExchangeRatesDTO) throws
    func needToUploadIcons() throws -> [CurrencyToLoadImageDTO]
    func updateImageFor(currency: CurrencyToLoadImageDTO) throws
}

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
extension CoreDataService: ICoreDataService {
    
    func updateFromNetwork(currencies: SupportedCurrenciesDTO) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: "Currency", in: persistentContainer.viewContext) else { return }
        let fetchRequest = Currency.fetchRequest()
        
        var newCurrencies = currencies
        let oldCurrencies = try persistentContainer.newBackgroundContext().fetch(fetchRequest)
        
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
        
        self.saveContext()
    }
    
    func updateFromNetwork(rates: LatestExchangeRatesDTO) throws {
        let fetchRequest = Currency.fetchRequest()
        
        let currencies = try persistentContainer.newBackgroundContext().fetch(fetchRequest)
        
        for (currencyCode, rate) in rates.rates {
            if let currency = currencies.first(where: { $0.currencyCode == currencyCode }) {
                currency.setValues(rate: rate, date: rates.date)
            }
        }
        
        self.saveContext()
    }
    
    func needToUploadIcons() throws -> [CurrencyToLoadImageDTO] {
        let fetchRequest = Currency.fetchRequest()
        let currencies = try persistentContainer.newBackgroundContext().fetch(fetchRequest)
        
        let result = currencies.compactMap { currency -> CurrencyToLoadImageDTO? in
            if currency.icon == nil {
                return CurrencyToLoadImageDTO(from: currency)
            }
            return nil
        }
        
        return result
    }
    
    func updateImageFor(currency: CurrencyToLoadImageDTO) throws {
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
