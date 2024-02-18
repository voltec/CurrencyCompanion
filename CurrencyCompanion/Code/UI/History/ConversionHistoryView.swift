//
//  ConversionHistoryView.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 18.02.2024.
//

import SwiftUI

struct ConversionHistoryView: View {
  @StateObject var viewModel = ConversionHistoryViewModel()
  @State private var isSearching = false

  var body: some View {
    List(viewModel.conversions) { conversion in
      VStack(alignment: .leading) {
        Text("\(conversion.baseCurrency) to \(conversion.targetCurrency)")
        Text("Amount: \(conversion.amount) -> \(conversion.convertedAmount)")
          .font(.subheadline)
          .foregroundColor(.gray)
      }
    }
    .navigationTitle("Conversion History")
    .searchable(text: $viewModel.searchText, prompt: "Search conversions")
    .toolbar {
      if isSearching {
        Button("Cancel") {
          isSearching = false
          viewModel.searchText = ""
          UIApplication.shared.endEditing()
        }
      }
    }
    .onChange(of: viewModel.searchText) { searchText in
      isSearching = !searchText.isEmpty
    }
  }
}

extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
