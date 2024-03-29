//
//  CurrencyRateView.swift
//  CurrencyCompanion
//
//  Created by Mikhail Mukminov on 17.02.2024.
//

import SwiftUI

struct CurrencyRateView: View {
  @StateObject private var viewModel = CurrencyRateViewModel()
  @EnvironmentObject private var router: CurrencyRouter
  @FocusState private var isTextFieldFocused: Bool

  private let accentColor = Color(red: 138 / 255, green: 43 / 255, blue: 226 / 255)

  var body: some View {
    mainView
      .alert(isPresented: $viewModel.showsError, error: viewModel.error, actions: {})
      .padding()
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text("CurrencyCompanion")
            .font(.system(size: 22).weight(.semibold))
            .tracking(0.66)
            .frame(height: 30)
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            router.navigate(to: .history)
          } label: {
            Text("History")
          }
        }
      }
  }

  private var mainView: some View {
    VStack {
      currencyPanel(title: "From", currency: $viewModel.baseCurrency)

      currencyPanel(title: "To", currency: $viewModel.targetCurrency)

      inputView

      resultView

      Spacer()
    }
  }

  @ViewBuilder
  private func currencyPanel(title: String, currency: Binding<Currency>) -> some View {
    VStack(alignment: .leading) {
      Text(title)
      Picker("Base Currency", selection: currency) {
        ForEach(Currency.allCases, id: \.self) { currency in
          Text(currency.rawValue).tag(currency)
        }
      }
      .pickerStyle(.segmented)
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 8)
        .stroke(lineWidth: 1)
        .foregroundStyle(accentColor.opacity(0.5))
    )
  }

  private var inputView: some View {
    TextField("Amount in \(viewModel.baseCurrency.rawValue)", text: $viewModel.amount)
      .keyboardType(.decimalPad)
      .focused($isTextFieldFocused)
      .padding(10)
      .background(Color.white)
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(accentColor.opacity(isTextFieldFocused ? 1 : 0.2), lineWidth: 2)
      )
  }

  private var resultView: some View {
    VStack {
      if let rate = viewModel.currencyRate {
        HStack(spacing: 0) {
          Text("Rate: ")
          if viewModel.isLoading {
            ProgressView()
              .progressViewStyle(.circular)
          } else {
            Text("\(rate.rate)")
          }
        }
      }

      if let convertedAmount = viewModel.convertedAmount {
        HStack(spacing: 0) {
          Text("Converted Amount: ")
          if viewModel.isLoading {
            ProgressView()
              .progressViewStyle(.circular)
          } else {
            Text("\(convertedAmount)")
            Text(" \(viewModel.targetCurrency.rawValue)")
          }
        }
      }
    }
  }
}

#Preview {
  DIContainer.shared.preview()
  return CurrencyRateView()
}
