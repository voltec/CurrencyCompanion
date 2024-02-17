//
//  DIContainer.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 18.02.2024.
//

import Foundation

protocol DIContainerProtocol {
  func register<Service>(type: Service.Type, component: Any)
  func inject<Service>(type: Service.Type) -> Service
}

final class DIContainer: DIContainerProtocol {
  enum Errors: Error {
    case serviceNotFound
  }

  static let shared = DIContainer()

  private init() {}

  private var services: [String: Any] = [:]

  func register(type: (some Any).Type, component service: Any) {
    services["\(type)"] = service
  }

  func inject<Service>(type: Service.Type) -> Service {
    guard let service = services["\(type)"] as? Service else {
      fatalError("Add this service!")
    }
    return service
  }
}

extension DIContainer {
  var database: DatabaseProtocol {
    inject(type: DatabaseProtocol.self)
  }

  var currencyRateService: CurrencyRateServiceProtocol {
    inject(type: CurrencyRateServiceProtocol.self)
  }

  var currencyRateRepository: CurrencyRateRepositoryProtocol {
    inject(type: CurrencyRateRepositoryProtocol.self)
  }

  func application() {
    // TODO: move to safe place
    let key = "fca_live_6OZRA9qjY37OUwoaOKUbWrOjund2jwm4262Tj9hZ"
    let currencyRateService: CurrencyRateServiceProtocol = CurrencyRateService(apiKey: key)
    let database = CoreDataDatabase(persistentContainer: PersistenceController.shared.container)
    let repository = CurrencyRateRepository(service: currencyRateService, database: database)
    register(type: DatabaseProtocol.self, component: database)
    register(type: CurrencyRateServiceProtocol.self, component: currencyRateService)
    register(type: CurrencyRateRepositoryProtocol.self, component: repository)
  }

  func preview() {
    let container = PersistenceController.preview.container
    let currencyRateService: CurrencyRateServiceProtocol = MockConversionService()
    let database = CoreDataDatabase(persistentContainer: container)
    let repository = CurrencyRateRepository(service: currencyRateService, database: database)
    register(type: DatabaseProtocol.self, component: database)
    register(type: CurrencyRateServiceProtocol.self, component: currencyRateService)
    register(type: CurrencyRateRepositoryProtocol.self, component: repository)
  }
}
