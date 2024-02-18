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
  private let conversionRepository: ConversionRepositoryProtocol
  private let userSettingsStorage: UserSettingsStoring

  @Published var baseCurrency: Currency = .usd
  @Published var targetCurrency: Currency = .eur
  @Published var amount: String = ""
  @Published var convertedAmount: Float?
  @Published var currencyRate: CurrencyRate?
  @Published var isLoading: Bool = false

  var error: ViewModelError?
  @Published var showsError: Bool = false

  private var cancellables: Set<AnyCancellable> = []

  init(diContainer: DIContainer = DIContainer.shared) {
    repository = diContainer.currencyRateRepository
    conversionRepository = diContainer.conversionRepository
    userSettingsStorage = diContainer.userSettingsStorage
    loadSettings()
    startObservers()
  }

  func startObservers() {
    $baseCurrency
      .combineLatest($targetCurrency, $amount)
      .sink { [unowned self] baseCurrency, targetCurrency, amount in
        saveSettings(base: baseCurrency, target: targetCurrency, amount: amount)
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
      convertedAmount = nil
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
    let value = amount * currencyRate.rate
    convertedAmount = value
    Task {
      await conversionRepository.saveConversion(Conversion(
        baseCurrency: currencyRate.baseCurrency,
        targetCurrency: currencyRate.targetCurrency,
        amount: amount,
        convertedAmount: value,
        date: Date()
      ))
    }
  }

  private func updateRate() async {
    let rate = try? await repository.fetchCurrencyRate(
      baseCurrency: baseCurrency.rawValue,
      targetCurrency: targetCurrency.rawValue,
      forceUpdate: false
    )
    currencyRate = rate
  }

  private func loadSettings() {
    if let settings = userSettingsStorage.loadCurrency() {
      baseCurrency = settings.baseCurrency
      targetCurrency = settings.targetCurrency
      amount = settings.amount
    }
  }

  private func saveSettings(base: Currency, target: Currency, amount: String) {
    userSettingsStorage.saveCurrency(baseCurrency: base, targetCurrency: target, amount: amount)
  }
}
