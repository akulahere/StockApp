//
//  ContentView.swift
//  StockApp
//
//  Created by Dmytro Akulinin on 20.01.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
  
  @ObservedObject private var model = ContentViewModel()
  
  var body: some View {
    NavigationView {
      List {
        if !model.stockData.isEmpty {
          ForEach(model.stockData) { stock in
            HStack {
              Text(stock.metaData.symbol)
              Spacer()
              RoundedRectangle(cornerRadius: 10)
                .frame(width: 150, height: 50)
              VStack(alignment: .trailing) {
                Text(stock.latestClose)
                Text("Change")
              }
            }
          }
        }

      }
      .navigationTitle("My Stocks")
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          EditButton()
        }
      }
    }
  }
  
  
}



struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
