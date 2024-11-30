//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Mai Hassen on 30/11/2024.
//

import SwiftUI
import CoreModule

@main
struct MovieAppApp: App {
    let persistenceController = PersistenceController.shared

      var body: some Scene {
          WindowGroup {
              ContentView()
                  .environment(\.managedObjectContext, persistenceController.viewContext)
          }
      }
}
