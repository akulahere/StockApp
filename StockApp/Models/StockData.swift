//
//  StockData.swift
//  StockApp
//
//  Created by Dmytro Akulinin on 23.01.2023.
//

import Foundation

struct StockData: Codable {
  struct MetaData: Codable {
    let Information: String
    let Symbol: String
    let LastRefreshed: String
    let Interval: String
    let OutputSize: String
    let TimeZone: String
    
    private enum CodingKeys: String, CodingKey {
      case Information = "1. Information"
      case Symbol = "2. Symbol"
      case LastRefreshed = "3. Last Refreshed"
      case Interval = "4. Interval"
      case OutputSize = "5. Output Size"
      case TimeZone = "6. Time Zone"
    }
  }
  
    struct StockDataEntry: Codable {
      let Open: String
      let High: String
      let Low: String
      let Close: String
      let Volume: String
      
      private enum CodingKeys: String, CodingKey {
        case Open = "1. open"
        case High = "2. high"
        case Low = "3. low"
        case Close = "4. close"
        case Volume = "5. volume"
      }
    }
  
  
  let metaData: MetaData
  let timeSeries5min: [String: StockDataEntry]
  
  private enum CodingKeys: String, CodingKey {
    case metaData = "Meta Data"
    case timeSeries5min = "Time Series (5min)"
  }
}
