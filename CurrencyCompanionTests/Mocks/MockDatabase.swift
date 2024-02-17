//
//  MockDatabase.swift
//  CurrencyCompanionTests
//
//  Created by Mikhail Mukminov on 17.02.2024.
//

@testable import CurrencyCompanion
import Foundation

class MockDatabase: DatabaseProtocol {
  var savedRates: [CurrencyRate] = []
  var shouldReturnRates = false

  func saveCurrencyRates(rates: [CurrencyRate]) async {
    savedRates = rates
  }

  func getCurrencyRate(base: String, target: String) -> CurrencyRate? {
    shouldReturnRates ? savedRates.filter({ $0.baseCurrency == base && $0.targetCurrency == target }).first : nil
  }

  func hasCurrencyRate(base: String, target: String) -> Bool {
    shouldReturnRates
  }
}
