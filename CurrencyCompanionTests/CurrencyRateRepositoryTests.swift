//
//  CurrencyRateRepositoryTests.swift
//  CurrencyCompanionTests
//
//  Created by Mikhail Mukminov on 17.02.2024.
//

@testable import CurrencyCompanion
import XCTest

final class CurrencyRateRepositoryTests: XCTestCase {
  var repository: CurrencyRateRepository!
  var mockService: MockConversionService!
  var mockDatabase: MockDatabase!

  override func setUpWithError() throws {
    mockService = MockConversionService()
    mockDatabase = MockDatabase()
    repository = CurrencyRateRepository(service: mockService, database: mockDatabase)
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testfetchCurrencyRate_UsesCachedData() async {
    mockDatabase.shouldReturnRates = true
    mockDatabase.savedRates = [CurrencyRate(baseCurrency: "USD", targetCurrency: "EUR", rate: 0.9)]

    let currencyRate = try! await repository.fetchCurrencyRate(
      baseCurrency: "USD",
      targetCurrency: "EUR",
      forceUpdate: false
    )

    XCTAssertNotNil(currencyRate)
    XCTAssertEqual(currencyRate.rate, 0.9)
  }

  func testfetchCurrencyRate_FetchesFromNetwork() async {
    mockService.mockData = CurrencyRate(baseCurrency: "USD", targetCurrency: "EUR", rate: 0.85)

    let currencyRate = try! await repository.fetchCurrencyRate(
      baseCurrency: "USD",
      targetCurrency: "EUR",
      forceUpdate: true
    )

    XCTAssertNotNil(currencyRate)
    XCTAssertEqual(currencyRate.rate, 0.85)
  }
}
