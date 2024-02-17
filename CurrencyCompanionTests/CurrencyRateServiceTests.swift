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

  func testfetchCurrencyRate() async {
    do {
      let rate = try await service.fetchCurrencyRate(baseCurrency: "USD", targetCurrency: "EUR")

      XCTAssertNotNil(rate)

      XCTAssertEqual(rate?.baseCurrency, "USD")
      XCTAssertEqual(rate?.targetCurrency, "EUR")

    } catch {
      XCTFail("Test failed with error: \(error)")
    }
  }
}
