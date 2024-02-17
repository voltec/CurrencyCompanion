//
//  CurrencyRateViewModelTests.swift
//  CurrencyCompanionTests
//
//  Created by Mikhail Mukminov on 18.02.2024.
//

@testable import CurrencyCompanion
import XCTest

class CurrencyRateViewModelTests: XCTestCase {
  @MainActor
  func testFetchCurrencyRateSuccess() async throws {
    let repository = MockCurrencyRateRepository()
    let expectedRate = CurrencyRate(baseCurrency: "USD", targetCurrency: "EUR", rate: 1.3)
    repository.expectedRate = expectedRate

    let viewModel = CurrencyRateViewModel(repository: repository)

    await viewModel.fetchCurrencyRate(baseCurrency: "USD", targetCurrency: "EUR", forceUpdate: false)

    XCTAssertEqual(viewModel.currencyRate, expectedRate)
  }

  @MainActor
  func testFetchCurrencyRateFailure() async throws {
    let repository = MockCurrencyRateRepository()
    repository.error = MockError.unknownError

    let viewModel = CurrencyRateViewModel(repository: repository)

    await viewModel.fetchCurrencyRate(baseCurrency: "USD", targetCurrency: "EUR", forceUpdate: false)

    XCTAssertNotNil(viewModel.error)
  }
}
