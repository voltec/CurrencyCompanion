//
//  Conversion.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 18.02.2024.
//

import Foundation

struct Conversion: Identifiable, Codable {
  var id = UUID()
  var baseCurrency: String
  var targetCurrency: String
  var amount: Float
  var convertedAmount: Float
  var date: Date
}
