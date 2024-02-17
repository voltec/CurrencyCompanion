//
//  CurrencyRateServiceTests.swift
//  CurrencyCompanionTests
//
//  Created by Mikhail Mukminov on 17.02.2024.
//

@testable import CurrencyCompanion
import XCTest

final class CurrencyRateServiceTests: XCTestCase {
  var service: CurrencyRateService!
  let testKey: String = "fca_live_6OZRA9qjY37OUwoaOKUbWrOjund2jwm4262Tj9hZ"

  override func setUpWithError() throws {
    service = CurrencyRateService(apiKey: testKey)
  }

  override func tearDownWithError() throws {
    service = nil
  }

  func testFetchCurrencyRates() async {
    do {
      let rates = try await service.fetchCurrencyRates(baseCurrency: "USD", targetCurrencies: ["EUR"])

      XCTAssertFalse(rates.isEmpty)

      let containsEUR = rates.contains { $0.targetCurrency == "EUR" }
      XCTAssertTrue(containsEUR)

    } catch {
      XCTFail("Test failed with error: \(error)")
    }
  }
}
