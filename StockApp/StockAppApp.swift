//
//  StockAppApp.swift
//  StockApp
//
//  Created by Dmytro Akulinin on 20.01.2023.
//

import SwiftUI

@main
struct StockAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
