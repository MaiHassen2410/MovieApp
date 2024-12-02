//
//  MovieEntity+CoreDataProperties.swift
//  MovieApp
//
//  Created by Mai Hassen on 02/12/2024.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var genreIDs: NSObject?
    @NSManaged public var id: Int64
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?

}

extension MovieEntity : Identifiable {

}
