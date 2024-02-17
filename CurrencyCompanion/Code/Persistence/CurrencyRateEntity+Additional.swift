//
//  CurrencyRateEntity+Additional.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 17.02.2024.
//

import Foundation
import CoreData

extension CurrencyRateEntity {
  class func fetchRequest(baseCurrency: String, targetCurrency: String) -> NSFetchRequest<CurrencyRateEntity> {
    let request = CurrencyRateEntity.fetchRequest()
    request.predicate = NSPredicate(format: "baseCurrency == %@ AND targetCurrency == %@", baseCurrency, targetCurrency)
    return request
  }
}
