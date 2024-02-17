//
//  MockDatabase.swift
//  CurrencyCompanionTests
//
//  Created by Mikhail Mukminov on 17.02.2024.
//

import Foundation

class MockDatabase: DatabaseProtocol {
  var savedRates: [CurrencyRate] = []
  var shouldReturnRates = false

  func saveCurrencyRates(rates: [CurrencyRate]) async {
    savedRates = rates
  }

  func getCurrencyRate(base: String, target: String) -> CurrencyRate? {
    shouldReturnRates ? savedRates.filter { $0.baseCurrency == base && $0.targetCurrency == target }.first : nil
  }

  func hasCurrencyRate(base _: String, target _: String) -> Bool {
    shouldReturnRates
  }
}
