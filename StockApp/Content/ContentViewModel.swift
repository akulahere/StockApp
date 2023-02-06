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
  private let context = PersistenceController.shared.container.viewContext
  
  private var cancellables = Set<AnyCancellable>()

  
  @Published var stockData: [StockData] = []
  @Published var symbol = ""
  @Published var stockEntities: [StockEntity] = []
  
  init() {
    loadFromCoreData()
    loadAllSymbols()
  }
  
  
  func loadFromCoreData() {
    do {
      stockEntities = try context.fetch(StockEntity.fetchRequest())
      print("Stocks: \(stockEntities)")
    }
    catch {
      print(error)
    }
  }
  
  func addStock() {
    let newStock = StockEntity(context: context)
    newStock.symbol = symbol
    do {
      try context.save()
    }
    catch {
      print(error)
    }
    stockEntities.append(newStock)
    print(stockEntities)
    getStockData(for: symbol)
    symbol = ""
  }
  
  func loadAllSymbols() {
    stockData = []
    stockEntities.forEach { stockEntity in
      getStockData(for: stockEntity.symbol ?? "")
    }
    print(stockData)
  }
  
  func delete(at indexSet: IndexSet) {
    guard let index = indexSet.first else { return }
    
    stockData.remove(at: index)
    let stockToRemove = stockEntities.remove(at: index)
    context.delete(stockToRemove)
    
    do {
      try context.save()
    } catch {
      print(error)
    }
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
      } receiveValue: {[weak self] stockData in
        DispatchQueue.main.async {
          self?.stockData.append(stockData)
        }
      }
      .store(in: &cancellables)
    
    
  }
}

