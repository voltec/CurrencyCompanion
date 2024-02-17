//
//  CurrencyRateViewModelTests.swift
//  CurrencyCompanionTests
//
//  Created by Mikhail Mukminov on 18.02.2024.
//

@testable import CurrencyCompanion
import XCTest

class CurrencyRateViewModelTests: XCTestCase {
  var viewModel: CurrencyRateViewModel!
  var mockRepository: MockCurrencyRateRepository!

  @MainActor
  override func setUpWithError() throws {
    // TODO: change to test
    DIContainer.shared.application()
    mockRepository = MockCurrencyRateRepository()
    viewModel = CurrencyRateViewModel(diContainer: DIContainer.shared)
  }

  @MainActor
  override func tearDownWithError() throws {
    mockRepository = nil
    viewModel = nil
  }

  @MainActor
  func testConversionUpdatesValuesCorrectly() async {
    viewModel.baseCurrency = .usd
    viewModel.targetCurrency = .eur
    viewModel.amount = "100"
    mockRepository.expectedRate = .init(baseCurrency: "USD", targetCurrency: "EUR", rate: 1)

    let expectation = XCTestExpectation(description: "Loading and conversion complete")

    var isLoadingChanged = false
    let cancellable = viewModel.$isLoading.dropFirst().sink { isLoading in
      isLoadingChanged = true
      if !isLoading {
        expectation.fulfill()
      }
    }

    viewModel.amount = "200"

    await fulfillment(of: [expectation], timeout: 5)

    XCTAssertTrue(isLoadingChanged, "isLoading should have changed.")
    XCTAssertNotNil(viewModel.convertedAmount, "convertedAmount should be updated.")
    XCTAssertFalse(viewModel.isLoading, "isLoading should be false after conversion.")

    cancellable.cancel()
  }
}
