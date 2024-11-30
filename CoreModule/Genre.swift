//
//  Genre.swift
//  CoreModule
//
//  Created by Mai Hassen on 30/11/2024.
//

import Foundation
public struct Genre: Identifiable, Codable, Equatable {
    public let id: Int
    public let name: String?

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

public struct GenreListResponse: Codable {
    public let genres: [Genre]?
    
    public init(genres: [Genre]) {
        self.genres = genres
    }
}
