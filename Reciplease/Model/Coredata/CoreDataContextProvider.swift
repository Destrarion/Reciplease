//
//  CoreDataContextProvider.swift
//  Reciplease
//
//  Created by Fabien Dietrich on 16/06/2021.
//

import Foundation
import CoreData

protocol CoreDataContextProviderProtocol {
    var viewContext: NSManagedObjectContext { get }
    
    func save() throws
    func delete(_ object: NSManagedObject)
    func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T] 
}


class CoreDataContextProvider: CoreDataContextProviderProtocol {
    
    static let shared = CoreDataContextProvider()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Reciplease")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }

    func save() throws {
        try viewContext.save()
    }
    
    func delete(_ object: NSManagedObject) {
        viewContext.delete(object)
    }
    
    func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T] {
        try viewContext.fetch(request)
    }
}




class CoreDataContextProviderMock: CoreDataContextProviderProtocol {
    
    static let shared = CoreDataContextProvider()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Reciplease")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }

    func save() throws {
        try viewContext.save()
    }
    
    func delete(_ object: NSManagedObject) {
        viewContext.delete(object)
    }
    
    func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T] {
        throw MockError.error
    }
}

enum MockError: Error {
    case error
}
