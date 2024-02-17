//
//  CurrencyCompanionApp.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 17.02.2024.
//

import SwiftUI

@main
struct CurrencyCompanionApp: App {
  init() {
    DIContainer.shared.application()
  }

  var body: some Scene {
    WindowGroup {
      RootView()
    }
  }
}
