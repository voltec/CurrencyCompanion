//
//  CoreDataDatabaseTests.swift
//  CurrencyCompanionTests
//
//  Created by Mikhail Mukminov on 17.02.2024.
//

import CoreData
@testable import CurrencyCompanion
import XCTest

final class CoreDataDatabaseTests: XCTestCase {
  var database: CoreDataDatabase!
  var persisnenceContainer: NSPersistentContainer!

  override func setUpWithError() throws {
    persisnenceContainer = PersistenceController(inMemory: true).container
    database = CoreDataDatabase(persistentContainer: persisnenceContainer)
  }

  override func tearDownWithError() throws {
    database = nil
    flushData()
  }

  func testSaveCurrencyRates() async {
    let ratesToSave: [CurrencyRate] = [
      CurrencyRate(baseCurrency: "USD", targetCurrency: "EUR", rate: 0.85),
      CurrencyRate(baseCurrency: "USD", targetCurrency: "GBP", rate: 0.72)
    ]

    await database.saveCurrencyRates(rates: ratesToSave)

    XCTAssertTrue(database.hasCurrencyRate(base: "USD", target: "EUR"))
    XCTAssertTrue(database.hasCurrencyRate(base: "USD", target: "GBP"))

    for saved in ratesToSave {
      let currency = database.getCurrencyRate(base: saved.baseCurrency, target: saved.targetCurrency)
      XCTAssertNotNil(currency)
      XCTAssertEqual(saved.rate, currency!.rate)
    }
  }

  private func flushData() {
    let context = persisnenceContainer.viewContext
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CurrencyRateEntity.fetchRequest()
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

    do {
      try context.execute(deleteRequest)
      try context.save()
    } catch {
      XCTFail("Failed to flush data from database with error: \(error)")
    }
  }
}
