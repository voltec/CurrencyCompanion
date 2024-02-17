//
//  CurrencyRouter.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 18.02.2024.
//

import Foundation

class CurrencyRouter: Router<CurrencyRouter.Destination> {
  enum Destination: Hashable {
    case history
  }
}
