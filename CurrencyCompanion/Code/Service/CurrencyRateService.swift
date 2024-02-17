//
//  CurrencyRateService.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 17.02.2024.
//

import Foundation

protocol ConversionServiceProtocol {
  func fetchCurrencyRate(baseCurrency: String, targetCurrency: String) async throws -> CurrencyRate?
}

struct CurrencyRateService: ConversionServiceProtocol {
  let apiKey: String
  let baseURL = "https://api.freecurrencyapi.com/v1/latest"

  func fetchCurrencyRate(baseCurrency: String, targetCurrency: String) async throws -> CurrencyRate? {
    let urlString = "\(baseURL)?apikey=\(apiKey)&currencies=\(targetCurrency)&base_currency=\(baseCurrency)"
    guard let url = URL(string: urlString) else {
      throw NetworkError.invalidURL
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    let decodedResponse = try JSONDecoder().decode(CurrencyRatesResponse.self, from: data)

    return decodedResponse.data.map { targetCurrency, rate in
      CurrencyRate(baseCurrency: baseCurrency, targetCurrency: targetCurrency, rate: rate)
    }.first
  }
}

enum NetworkError: Error {
  case invalidURL, requestFailed, invalidResponse
}

struct CurrencyRatesResponse: Codable {
  let data: [String: Float]
}
