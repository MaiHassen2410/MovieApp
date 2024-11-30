//
//  ContentView.swift
//  MovieApp
//
//  Created by Mai Hassen on 30/11/2024.
//

import SwiftUI
import CoreData
import TrendingMoviesModule
import CoreModule

struct ContentView: View {
    var body: some View {
        NavigationView {
            // Use TrendingMoviesView as the root view
            TrendingMoviesView(viewModel: TrendingMoviesViewModel())
        }
    }
}

// Preview
#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.viewContext)
}
