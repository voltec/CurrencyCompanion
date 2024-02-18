//
//  ConversionRepository.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 18.02.2024.
//

import CoreData
import Foundation

protocol ConversionRepositoryProtocol {
  func fetchConversions(with searchText: String?) async throws -> [Conversion]
  func saveConversion(_ conversion: Conversion) async
}

extension ConversionRepositoryProtocol {
  func fetchConversions() async throws -> [Conversion] {
    try await fetchConversions(with: nil)
  }
}

class ConversionRepository: ConversionRepositoryProtocol {
  private let persistentContainer: NSPersistentContainer

  init(container: NSPersistentContainer) {
    persistentContainer = container
  }

  @MainActor
  func fetchConversions(with searchText: String? = nil) async throws -> [Conversion] {
    let request = ConversionEntity.fetchRequest()

    if let searchText, !searchText.isEmpty {
      request.predicate = NSPredicate(
        format: "baseCurrency CONTAINS[cd] %@ OR targetCurrency CONTAINS[cd] %@",
        searchText,
        searchText
      )
    }
    request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

    let context = persistentContainer.viewContext
    let result = try context.fetch(request)

    return result.compactMap { Conversion(entity: $0) }
  }

  func saveConversion(_ conversion: Conversion) async {
    let context = persistentContainer.newBackgroundContext()
    context.performAndWait {
      let entity = ConversionEntity(context: context)
      entity.id = conversion.id
      entity.baseCurrency = conversion.baseCurrency
      entity.targetCurrency = conversion.targetCurrency
      entity.amount = conversion.amount
      entity.convertedAmount = conversion.convertedAmount
      entity.date = conversion.date

      try? context.save()
    }
  }
}

extension Conversion {
  init?(entity: ConversionEntity) {
    guard let id = entity.id,
          let baseCurrency = entity.baseCurrency,
          let targetCurrency = entity.targetCurrency,
          let date = entity.date
    else { return nil }
    self.init(
      id: id,
      baseCurrency: baseCurrency,
      targetCurrency: targetCurrency,
      amount: entity.amount,
      convertedAmount: entity.convertedAmount,
      date: date
    )
  }
}
