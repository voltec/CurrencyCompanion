//
//  Router.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 18.02.2024.
//

import SwiftUI

class Router<Destination>: ObservableObject where Destination: Hashable {
  @Published var navPath = NavigationPath()

  func navigate(to destination: Destination) {
    navPath.append(destination)
  }

  func navigateBack() {
    navPath.removeLast()
  }

  func navigateToRoot() {
    navPath.removeLast(navPath.count)
  }
}
