//
//  Persistence.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 17.02.2024.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()

  let container: NSPersistentContainer

  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "CurrencyCompanion")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function
        // in a shipping application, although it may be useful during development.

        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    container.viewContext.automaticallyMergesChangesFromParent = true
  }
}

// Preview
extension PersistenceController {
  private static func addCurrencyEntity(context: NSManagedObjectContext, currency: CurrencyRate) {
    let entity = CurrencyRateEntity(context: context)
    entity.baseCurrency = currency.baseCurrency
    entity.targetCurrency = currency.targetCurrency
    entity.rate = currency.rate
    entity.lastUpdated = currency.lastUpdated
  }

  static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext

    do {
      addCurrencyEntity(
        context: viewContext,
        currency: CurrencyRate(baseCurrency: "USD", targetCurrency: "RUB", rate: 345)
      )
      addCurrencyEntity(
        context: viewContext,
        currency: CurrencyRate(baseCurrency: "USD", targetCurrency: "EUR", rate: 123)
      )
      addCurrencyEntity(
        context: viewContext,
        currency: CurrencyRate(baseCurrency: "USD", targetCurrency: "GBP", rate: 765)
      )
      addCurrencyEntity(
        context: viewContext,
        currency: CurrencyRate(baseCurrency: "USD", targetCurrency: "CHF", rate: 765)
      )
      addCurrencyEntity(
        context: viewContext,
        currency: CurrencyRate(baseCurrency: "USD", targetCurrency: "CNY", rate: 123)
      )

      try viewContext.save()
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in
      // a shipping application, although it may be useful during development.
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
    return result
  }()
}
