//
//  Movie.swift
//  CoreModule
//
//  Created by Mai Hassen on 30/11/2024.
//

import Foundation
public struct Movie: Identifiable, Codable, Equatable {
    public let id: Int
    public let title: String?
    public let posterPath: String?
    public let releaseDate: String?
    public let overview: String?
    public let genreIDs: [Int]? 
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case genreIDs = "genre_ids"
        case overview
    }
    public init(id: Int, title: String, posterPath: String?, releaseDate: String, genreIDs: [Int], overview: String) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.genreIDs = genreIDs
        self.overview = overview
    }
}

public struct MovieListResponse: Codable {
    public let page: Int?
    public let results: [Movie]
    public let totalResults: Int?
    public let totalPages: Int?
    

    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalResults = "total_results"
        case totalPages = "total_pages"
      
    }
    
    public init(page: Int, results: [Movie], totalResults: Int, totalPages: Int) {
        self.page = page
        self.results = results
        self.totalResults = totalResults
        self.totalPages = totalPages
    
    }
}
