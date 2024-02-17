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
  private let refreshInterval: TimeInterval

  init(service: ConversionServiceProtocol, database: DatabaseProtocol, refreshInterval: TimeInterval = 60 * 1) {
    self.service = service
    self.database = database
    self.refreshInterval = refreshInterval
  }

  func fetchCurrencyRate(baseCurrency: String, targetCurrency: String, forceUpdate: Bool = false) async throws -> CurrencyRate {
    var rate = database.getCurrencyRate(base: baseCurrency, target: targetCurrency)
    
    if forceUpdate || rate == nil || (rate?.lastUpdated.timeIntervalSinceNow ?? 0) < -refreshInterval {
      rate = try await service.fetchCurrencyRate(baseCurrency: baseCurrency, targetCurrency: targetCurrency)
      if let newRate = rate {
        await database.saveCurrencyRates(rates: [newRate])
      }
    }
    
    guard let finalRate = rate else {
      throw Errors.currenciesNotFound
    }
    
    return finalRate
  }
}
