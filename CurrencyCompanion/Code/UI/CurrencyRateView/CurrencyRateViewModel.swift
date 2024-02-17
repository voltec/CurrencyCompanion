//
//  CurrencyRateViewModel.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 18.02.2024.
//

import Combine
import Foundation

enum Currency: String, CaseIterable {
  case rub = "RUB"
  case usd = "USD"
  case eur = "EUR"
  case gbp = "GBP"
  case chf = "CHF"
  case cny = "CNY"
}

@MainActor
final class CurrencyRateViewModel: ObservableObject {
  enum ViewModelError: LocalizedError {
    case failed

    var errorDescription: String? {
      switch self {
      case .failed:
        "Failed to retrieve data due to unknown reasons. Please try again later."
      }
    }
  }

  private let repository: CurrencyRateRepositoryProtocol

  @Published var baseCurrency: Currency = .usd
  @Published var targetCurrency: Currency = .eur
  @Published var amount: String = ""
  @Published var convertedAmount: Float?
  @Published var currencyRate: CurrencyRate?
  @Published var isLoading: Bool = false

  var error: ViewModelError?
  @Published var showsError: Bool = false
  
  private var cancellables: Set<AnyCancellable> = []

  init(repository: CurrencyRateRepositoryProtocol = DIContainer.shared.currencyRateRepository) {
    self.repository = repository
    startObservers()
  }

  func startObservers() {
    $baseCurrency
      .combineLatest($targetCurrency)
      .combineLatest($amount)
      .sink { [unowned self] _, _ in
        convertAmount()
      }
      .store(in: &cancellables)
  }
  
  private func showError(_ error: ViewModelError) {
    self.error = error
    showsError = true
  }

  private func convertAmount() {
    guard let amountDouble = Float(amount), amountDouble > 0 else {
      self.convertedAmount = nil
      return
    }
    isLoading = true
    Task(priority: .userInitiated) {
      await updateRate()
      calculate(amount: amountDouble)
      isLoading = false
    }
  }
  
  private func calculate(amount: Float) {
    guard let currencyRate else {
      showError(.failed)
      return
    }
    self.convertedAmount = amount * currencyRate.rate
  }

  private func updateRate() async {
    do {
      let rate = try await repository.fetchCurrencyRate(
        baseCurrency: baseCurrency.rawValue,
        targetCurrency: targetCurrency.rawValue,
        forceUpdate: false
      )
      currencyRate = rate
    } catch {
      self.error = ViewModelError.failed
      self.showsError = true
    }
  }
}
