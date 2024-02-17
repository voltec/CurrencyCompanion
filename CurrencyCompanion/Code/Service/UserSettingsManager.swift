//
//  UserSettingsManager.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 18.02.2024.
//

import Foundation

protocol UserSettingsStoring {
  func saveCurrency(baseCurrency: Currency, targetCurrency: Currency, amount: String)
  func loadCurrency() -> (baseCurrency: Currency, targetCurrency: Currency, amount: String)?
}

class UserSettingsManager: UserSettingsStoring {
  enum UserDefaultsKeys: String {
    case baseCurrency
    case targetCurrency
    case amount
  }

  func saveCurrency(baseCurrency: Currency, targetCurrency: Currency, amount: String) {
    UserDefaults.standard.set(baseCurrency.rawValue, forKey: UserDefaultsKeys.baseCurrency.rawValue)
    UserDefaults.standard.set(targetCurrency.rawValue, forKey: UserDefaultsKeys.targetCurrency.rawValue)
    UserDefaults.standard.set(amount, forKey: UserDefaultsKeys.amount.rawValue)
  }

  func loadCurrency() -> (baseCurrency: Currency, targetCurrency: Currency, amount: String)? {
    guard let baseCurrencyString = UserDefaults.standard.string(forKey: UserDefaultsKeys.baseCurrency.rawValue),
          let targetCurrencyString = UserDefaults.standard.string(forKey: UserDefaultsKeys.targetCurrency.rawValue),
          let amount = UserDefaults.standard.string(forKey: UserDefaultsKeys.amount.rawValue),
          let baseCurrency = Currency(rawValue: baseCurrencyString),
          let targetCurrency = Currency(rawValue: targetCurrencyString)
    else {
      return nil
    }

    return (baseCurrency, targetCurrency, amount)
  }
}
