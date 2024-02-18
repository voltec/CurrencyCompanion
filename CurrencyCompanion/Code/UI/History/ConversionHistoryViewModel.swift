//
//  ConversionHistoryViewModel.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 18.02.2024.
//

import Combine
import Foundation

@MainActor
class ConversionHistoryViewModel: ObservableObject {
  @Published var conversions: [Conversion] = []
  @Published var searchText = ""

  private let conversionRepository: ConversionRepositoryProtocol
  private var cancellables: Set<AnyCancellable> = []

  init(diContainer: DIContainer = DIContainer.shared) {
    conversionRepository = diContainer.conversionRepository
    startObservers()
  }

  private func startObservers() {
    $searchText.sink { [unowned self] text in
      loadConversions(search: text)
    }
    .store(in: &cancellables)
  }

  private func loadConversions(search: String) {
    Task {
      do {
        conversions = try await conversionRepository.fetchConversions(with: search)
      } catch {}
    }
  }
}
