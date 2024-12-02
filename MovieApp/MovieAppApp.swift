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
    let persistenceController = CoreDataManager.shared
    let networkManager = NetworkManager()

    init() {
         setupValueTransformers()
         configureImageCache()
     }

      var body: some Scene {
          WindowGroup {
              ContentView()
                  .environment(\.managedObjectContext, persistenceController.context)
          }
      }
    
    private func setupValueTransformers() {
        ValueTransformer.setValueTransformer(ArrayTransformer(), forName: NSValueTransformerName("ArrayTransformer"))
    }
    
    private func configureImageCache() {
         let imageCache = URLCache(
             memoryCapacity: 50 * 1024 * 1024, // 50 MB memory
             diskCapacity: 100 * 1024 * 1024,  // 100 MB disk
             diskPath: "imageCache"
         )
         URLCache.shared = imageCache
     }
    

}
