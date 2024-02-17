//
//  MockConversionService.swift
//  CurrencyCompanionTests
//
//  Created by Mikhail Mukminov on 17.02.2024.
//

@testable import CurrencyCompanion
import Foundation

class MockConversionService: ConversionServiceProtocol {
  var mockData: CurrencyRate?
  var mockError: Error?

  func fetchCurrencyRate(baseCurrency: String, targetCurrency: String) async throws -> CurrencyRate? {
    if let error = mockError {
      throw error
    }
    return mockData
  }
}
