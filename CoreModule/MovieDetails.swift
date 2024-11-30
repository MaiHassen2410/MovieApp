//
//  MovieDetails.swift
//  CoreModule
//
//  Created by Mai Hassen on 30/11/2024.
//

import Foundation
public struct MovieDetails: Codable {

    public let title: String
    public let overview: String
    public let homepage: String
    public let budget: Int
    public let revenue: Int
    public let spokenLanguages: [SpokenLanguage]
    public let status: String
    public let runtime: Int
    public let posterPath: String
    public let releaseDate: String
    public let genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case overview
        case homepage
        case budget
        case revenue
        case releaseDate = "release_date"
        case spokenLanguages = "spoken_languages"
        case status
        case runtime
        case posterPath = "poster_path" 
        case genres
    
    }
    public init(title: String, overview: String, homepage: String, budget: Int, revenue: Int, spokenLanguages: [SpokenLanguage], status: String, runtime: Int, posterPath: String, releaseDate: String, genres: [Genre]) {
        self.title = title
        self.overview = overview
        self.homepage = homepage
        self.budget = budget
        self.revenue = revenue
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.runtime = runtime
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.genres = genres
    }
}



public struct SpokenLanguage: Codable {
    public  let name: String
}
