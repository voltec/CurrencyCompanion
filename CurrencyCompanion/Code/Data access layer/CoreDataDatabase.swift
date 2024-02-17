//
//  CoreDataDatabase.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 17.02.2024.
//

import CoreData
import Foundation

protocol DatabaseProtocol {
  func saveCurrencyRates(rates: [CurrencyRate]) async
  func getCurrencyRate(base: String, target: String) -> CurrencyRate?
  func hasCurrencyRate(base: String, target: String) -> Bool
}

class CoreDataDatabase: DatabaseProtocol {
  private let persistentContainer: NSPersistentContainer
  private var viewContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }

  init(persistentContainer: NSPersistentContainer) {
    self.persistentContainer = persistentContainer
  }

  func saveCurrencyRates(rates: [CurrencyRate]) async {
    let context = persistentContainer.newBackgroundContext()
    await context.perform {
      for rate in rates {
        let request = CurrencyRateEntity.fetchRequest(
          baseCurrency: rate.baseCurrency,
          targetCurrency: rate.targetCurrency
        )
        request.fetchLimit = 1
        let results = try? context.fetch(request)
        let entity = results?.first ?? CurrencyRateEntity(context: context)
        entity.baseCurrency = rate.baseCurrency
        entity.targetCurrency = rate.targetCurrency
        entity.rate = rate.rate
        entity.lastUpdated = rate.lastUpdated
      }
    }
    do {
      try context.save()
    } catch {
      context.rollback()
    }
  }

  func getCurrencyRate(base: String, target: String) -> CurrencyRate? {
    let request = CurrencyRateEntity.fetchRequest(baseCurrency: base, targetCurrency: target)
    request.fetchLimit = 1
    let context = viewContext
    let results = try? context.fetch(request)

    return results?.first.map { $0.asCurrencyRate() }
  }

  func hasCurrencyRate(base: String, target: String) -> Bool {
    let context = viewContext
    let request = CurrencyRateEntity.fetchRequest(baseCurrency: base, targetCurrency: target)
    request.fetchLimit = 1
    do {
      let count = try context.count(for: request)
      return count > 0
    } catch {
      print("Failed to count currency rates: \(error)")
      return false
    }
  }
}

private extension CurrencyRateEntity {
  func asCurrencyRate() -> CurrencyRate {
    CurrencyRate(
      baseCurrency: baseCurrency ?? "",
      targetCurrency: targetCurrency ?? "",
      rate: rate,
      lastUpdated: Date()
    )
  }
}
