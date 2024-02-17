//
//  CurrencyRate.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 17.02.2024.
//

import Foundation

struct CurrencyRate: Equatable {
  let baseCurrency: String
  let targetCurrency: String
  let rate: Float
  var lastUpdated: Date = .init()
}
