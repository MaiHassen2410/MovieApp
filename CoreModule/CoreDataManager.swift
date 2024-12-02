//
//  CoreDataManager.swift
//  CoreModule
//
//  Created by Mai Hassen on 02/12/2024.
//

import Foundation
import CoreData


public class CoreDataManager {
    public static let shared = CoreDataManager()
    private init() {}
    
    func createManagedObjectModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        model.entities = [createGenreEntity(), createMovieEntity()]
        return model
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieAppModel", managedObjectModel: createManagedObjectModel())
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

 public    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
 
    public func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Unresolved error \(error)")
            }
        }
    }
 

    func createGenreEntity() -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = "GenreEntity"
        entity.managedObjectClassName = NSStringFromClass(GenreEntity.self)

        // Define attributes
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .integer64AttributeType
        idAttribute.isOptional = false

        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.attributeType = .stringAttributeType
        nameAttribute.isOptional = true

        // Add attributes to the entity
        entity.properties = [idAttribute, nameAttribute]

        return entity
    }

    func createMovieEntity() -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = "MovieEntity"
        entity.managedObjectClassName = NSStringFromClass(MovieEntity.self)

        // Define attributes
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .integer64AttributeType
        idAttribute.isOptional = false

        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.attributeType = .stringAttributeType
        titleAttribute.isOptional = true

        let posterPathAttribute = NSAttributeDescription()
        posterPathAttribute.name = "posterPath"
        posterPathAttribute.attributeType = .stringAttributeType
        posterPathAttribute.isOptional = true

        let releaseDateAttribute = NSAttributeDescription()
        releaseDateAttribute.name = "releaseDate"
        releaseDateAttribute.attributeType = .stringAttributeType
        releaseDateAttribute.isOptional = true

        let overviewAttribute = NSAttributeDescription()
        overviewAttribute.name = "overview"
        overviewAttribute.attributeType = .stringAttributeType
        overviewAttribute.isOptional = true

        let genreIDsAttribute = NSAttributeDescription()
        genreIDsAttribute.name = "genreIDs"
        genreIDsAttribute.attributeType = .transformableAttributeType
        genreIDsAttribute.isOptional = true
        genreIDsAttribute.valueTransformerName = "ArrayTransformer" // Ensure you have registered this transformer

        // Add attributes to the entity
        entity.properties = [idAttribute, titleAttribute, posterPathAttribute, releaseDateAttribute, overviewAttribute, genreIDsAttribute]

        return entity
    }

   
}


//saving data

extension CoreDataManager {
    public func saveGenres(_ genres: [Genre]) {
        for genre in genres {
            let genreEntity = GenreEntity(context: context)
            genreEntity.id = Int64(genre.id)
            genreEntity.name = genre.name
        }
        saveContext()
    }

   
        public func saveMovies(_ movies: [Movie]) {
            for movie in movies {
                let movieEntity = MovieEntity(context: context)
                movieEntity.id = Int64(movie.id)
                movieEntity.title = movie.title
                movieEntity.posterPath = movie.posterPath
                movieEntity.releaseDate = movie.releaseDate
                movieEntity.overview = movie.overview
                movieEntity.genreIDs = movie.genreIDs as? NSObject // Assign the array of Int
            }
            saveContext()
        
    }

    

}
// fetching data
extension CoreDataManager {
    
    private func fetchGenresByIDs(_ ids: [Int]) -> [GenreEntity] {
        let request: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", ids)
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching genres by IDs: \(error)")
            return []
        }
    }

    public func fetchMovies() -> [Movie] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do {
            let movieEntities = try context.fetch(request)
            return movieEntities.compactMap { entity in
                 let genreIDs = entity.genreIDs as? [Int]
                return Movie(
                    id: Int(entity.id),
                    title: entity.title ?? "",
                    posterPath: entity.posterPath,
                    releaseDate: entity.releaseDate ?? "",
                    genreIDs: genreIDs ?? [],
                    overview: entity.overview ?? ""
                )
            }
        } catch {
            print("Error fetching movies: \(error)")
            return []
        }
    }

    public func fetchGenres() -> [Genre] {
        let request: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        do {
            let genreEntities = try context.fetch(request)
            return genreEntities.map { entity in
                Genre(id: Int(entity.id), name: entity.name ?? "")
            }
        } catch {
            print("Error fetching genres: \(error)")
            return []
        }
    }
}
