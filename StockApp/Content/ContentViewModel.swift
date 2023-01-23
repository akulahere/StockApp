//
//  ContentViewModel.swift
//  StockApp
//
//  Created by Dmytro Akulinin on 23.01.2023.
//

import Foundation
import SwiftUI
import Combine

final class ContentViewModel: ObservableObject {
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    getStockData(for: "IBM")
  }
  func getStockData(for symbol: String) {
    let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(symbol)&interval=5min&apikey=\(APIKEY)")!

    URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { element -> Data in
        guard let httpResponse = element.response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
          throw URLError(.badServerResponse)
        }
        return element.data
              
      }
      .decode(type: StockData.self, decoder: JSONDecoder())
      .sink { completion in
        switch completion {
        case .failure(let error):
          print(error)
          return
        case .finished:
          return
        }
      } receiveValue: { stockData in
        print(stockData)
      }
      .store(in: &cancellables)
    

  }
}

