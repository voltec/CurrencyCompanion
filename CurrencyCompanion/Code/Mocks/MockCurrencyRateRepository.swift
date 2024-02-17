//
//  MockCurrencyRateRepository.swift
//  CurrencyCompanionTests
//
//  Created by Mikhail Mukminov on 18.02.2024.
//

import Foundation

enum MockError: Error {
  case unknownError
}

class MockCurrencyRateRepository: CurrencyRateRepositoryProtocol {
  var expectedRate: CurrencyRate?
  var error: Error?

  func fetchCurrencyRate(baseCurrency _: String, targetCurrency _: String,
                         forceUpdate _: Bool)
    async throws -> CurrencyRate
  {
    if let error {
      throw error
    }
    return expectedRate!
  }
}
