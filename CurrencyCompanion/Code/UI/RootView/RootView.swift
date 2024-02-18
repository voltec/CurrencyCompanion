//
//  RootView.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 18.02.2024.
//

import SwiftUI

struct RootView: View {
  @StateObject var router = CurrencyRouter()
  var body: some View {
    NavigationStack(path: $router.navPath) {
      CurrencyRateView()
        .environmentObject(router)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: CurrencyRouter.Destination.self) { destination in
          switch destination {
          case .history:
            ConversionHistoryView()
          }
        }
    }
  }
}
