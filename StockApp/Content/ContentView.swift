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
        HStack {
          TextField("Symbol", text: $model.symbol)
            .textFieldStyle(RoundedBorderTextFieldStyle())
          Button("Add", action: model.addStock)
        }
        if !model.stockData.isEmpty {
          ForEach(model.stockData) { stock in
            HStack {
              Text(stock.metaData.symbol)
              Spacer()
              LineChart(values: stock.closeValues)
                .fill(
                  LinearGradient(
                    gradient: Gradient(colors: [.green.opacity(0.7), .green.opacity(0.2), .green.opacity(0)]),
                    startPoint: .top,
                    endPoint: .bottom
                  )
                )
                .frame(width: 150, height: 50)
              VStack(alignment: .trailing) {
                Text(stock.latestClose)
              }
            }
          }
          .onDelete(perform: model.delete(at:))
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
