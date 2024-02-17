//
//  CurrencyRateRepository.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 17.02.2024.
//

import Foundation

protocol CurrencyRateRepositoryProtocol {
  func fetchCurrencyRate(baseCurrency: String, targetCurrencies: [String], forceUpdate: Bool) async throws
    -> [CurrencyRate]
}

class CurrencyRateRepository {
  enum Errors: Error {
    case currenciesNotFound
  }
  private let service: ConversionServiceProtocol
  private let database: DatabaseProtocol

  init(service: ConversionServiceProtocol, database: DatabaseProtocol) {
    self.service = service
    self.database = database
  }

  func fetchCurrencyRate(baseCurrency: String, targetCurrency: String, forceUpdate: Bool = false) async throws -> CurrencyRate
  {
    var rate = database.getCurrencyRate(base: baseCurrency, target: targetCurrency)
    if forceUpdate || rate == nil {
      rate = try await service.fetchCurrencyRate(baseCurrency: baseCurrency, targetCurrency: targetCurrency)
      if let rate {
        await database.saveCurrencyRates(rates: [rate])
      }
    }
    guard let rate else {
      throw Errors.currenciesNotFound
    }
    return rate
  }
}
