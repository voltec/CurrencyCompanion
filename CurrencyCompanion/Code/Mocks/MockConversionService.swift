//
//  MockConversionService.swift
//  CurrencyCompanionTests
//
//  Created by Mikhail Mukminov on 17.02.2024.
//

import Foundation

class MockConversionService: CurrencyRateServiceProtocol {
  var mockData: CurrencyRate?
  var mockError: Error?

  func fetchCurrencyRate(baseCurrency _: String, targetCurrency _: String) async throws -> CurrencyRate? {
    if let error = mockError {
      throw error
    }
    return mockData
  }
}
