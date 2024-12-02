//
//  GenreEntity+CoreDataProperties.swift
//  MovieApp
//
//  Created by Mai Hassen on 02/12/2024.
//
//

import Foundation
import CoreData


extension GenreEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GenreEntity> {
        return NSFetchRequest<GenreEntity>(entityName: "GenreEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}

extension GenreEntity : Identifiable {

}


