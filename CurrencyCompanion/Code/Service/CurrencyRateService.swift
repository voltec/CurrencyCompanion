//
//  CurrencyRateService.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 17.02.2024.
//

import Foundation

protocol ConversionServiceProtocol {
  func fetchCurrencyRates(baseCurrency: String, targetCurrencies: [String]) async throws -> [CurrencyRate]
}

struct CurrencyRateService: ConversionServiceProtocol {
  let apiKey: String
  let baseURL = "https://api.freecurrencyapi.com/v1/latest"

  func fetchCurrencyRates(baseCurrency: String, targetCurrencies: [String]) async throws -> [CurrencyRate] {
    let currenciesString = targetCurrencies.joined(separator: ",")
    let urlString = "\(baseURL)?apikey=\(apiKey)&currencies=\(currenciesString)&base_currency=\(baseCurrency)"
    guard let url = URL(string: urlString) else {
      throw NetworkError.invalidURL
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    let decodedResponse = try JSONDecoder().decode(CurrencyRatesResponse.self, from: data)

    return decodedResponse.data.map { targetCurrency, rate in
      CurrencyRate(baseCurrency: baseCurrency, targetCurrency: targetCurrency, rate: rate)
    }
  }
}

enum NetworkError: Error {
  case invalidURL, requestFailed, invalidResponse
}

struct CurrencyRatesResponse: Codable {
  let data: [String: Double]
}

class MockConversionService: ConversionServiceProtocol {
  var mockData: [CurrencyRate]?
  var mockError: Error?

  func fetchCurrencyRates(baseCurrency _: String, targetCurrencies _: [String]) async throws -> [CurrencyRate] {
    if let error = mockError {
      throw error
    }
    return mockData ?? []
  }
}
