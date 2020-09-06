//
//  CoreDataManager.swift
//  Pokedex
//
//  Created by owee on 05/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

/// Help to Manage CoreData Entities with basic operations :
/// Fetch, Create, Get, Delete, Save and Clear.
///
/// Fetching uses NSPredicate with The String Format.
///
/// Each operations (except save) **did'nt save the commit change**,
/// we recommend to implement them.
///
/// If you crash with create, check you entity class module
/// and turn it on *Current Product Module*
protocol CoreDataHelperProtocol {
    
    associatedtype Entity : NSManagedObject
    
    var persistentContainer: NSPersistentCloudKitContainer {get}
        
    func fetch(Predicate:String?,Limit:Int?) -> Result<[Entity],Error>
    
    func create() -> Entity
    func get(Predicate:String) -> Entity?
    func delete(Entity:Entity)
    func save()
    func clear()
    
}

/// Generique implementation of CoreDataHelperProtocol,
/// This generic shared the registed PersistentContaint for
/// each Entity his support.
///
/// To avoid loading delay from the persistentContainer,
/// we recommend to regist into the SceneDelegate.
class CoreDataStore<T:NSManagedObject> : CoreDataHelperProtocol {
        
    typealias Entity = T
    
    static func register(ContainerName:String) {
        SharedContainer.shared.setContainer(Name: ContainerName)
    }
    
    var persistentContainer: NSPersistentCloudKitContainer {
        return SharedContainer.shared.persistentContainer
    }

}

// MARK: - Implementation

extension CoreDataHelperProtocol {
    
    /// Use the app persistentContainer.
    var context : NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    /// Fetch entity with matching predicate as a Result. Without or nil predicate return all Entities.
    /// - Parameter Predicate: With String Swift format only. Like "id == \(yourModel.id)".
    /// - Parameter Limit: Optional limit the request.
    /// - Returns: The fetch results
    func fetch(Predicate:String?=nil, Limit:Int?=nil) -> Result<[Entity],Error> {
        
        let request = Entity.fetchRequest()
        
        if let predicate = Predicate {
            request.predicate = NSPredicate(format: predicate)
        }
        
        if let limit = Limit {
            request.fetchLimit = limit
        }
        
        do {
            
            let result = try self.context.fetch(request)
            return .success(result as? [Entity] ?? [])
            
        } catch let error {
            return .failure(error)
        }
    }
    
    /// Create and return a new empty entity.
    /// - Returns: Entity insered into default app Context.
    func create() -> Entity {
        return Entity(context: self.context)
    }
    
    /// Get the first result of predicate
    /// - Parameter Predicate: With String Swift format only. Like "id == \(yourModel.id)"
    func get(Predicate:String) -> Entity? {
        return try? self.fetch(Predicate: Predicate, Limit: 1).get().first
    }
    
    /// Delete the entity from its context
    /// - Parameter Entity: Entity to remove
    func delete(Entity: Entity) {
        self.context.delete(Entity)
    }
    
    /// Save the commit change (ignore error)
    func save() {
        try? self.context.save()
    }
    
    /// Remove all entity
    func clear() {
        
        let allObjects = self.fetch()
        
        switch allObjects {
            
        case .success(let result):
            
            result.forEach { (ent) in
                self.context.delete(ent)
            }
            
        default: break
        }
    }
}

private class SharedContainer {
    
    private init() {}
    static let shared = SharedContainer()
    
    var persistentContainer : NSPersistentCloudKitContainer!
    
    func setContainer(Name:String) {
        
        let container = NSPersistentCloudKitContainer(name: Name)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                print("[CoreStore] : Success to load CoreDataModel \(Name).xcdatamodel.")
            }
        })
        
        self.persistentContainer = container
    }
}
