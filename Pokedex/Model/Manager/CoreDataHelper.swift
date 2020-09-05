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

protocol CoreDataHelper {
    
    associatedtype Ent : NSManagedObject
    
    var fetchRequest : NSFetchRequest<Ent> {get}
    
    func fetch(Predicate:String?) -> Result<[Ent],Error>
    
    func create() -> Ent
    func get(Predicate:String) -> Ent?
    func delete(Entity:Ent)
    func save()
    func clear()
    
}

extension CoreDataHelper {

    var context : NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    /// Fetch entity with matching predicate as a Result. Without or nil predicate return all Entities.
    /// - Parameter Predicate: With String Swift format only. Like "id == \(yourModel.id)"
    /// - Returns: The fetch results
    func fetch(Predicate:String?=nil) -> Result<[Ent],Error> {
        
        let request = self.fetchRequest
        
        if let predicate = Predicate {
            request.predicate = NSPredicate(format: predicate)
        }
        
        do {
            
            let result = try self.context.fetch(request)
            return .success(result)
            
        } catch let error {
            return .failure(error)
        }
    }
    
    /// Create and return a new empty entity.
    /// - Returns: Entity insered into default app Context.
    func create() -> Ent {
        return Ent.self(context: self.context)
    }
    
    /// Get the first result of predicate
    /// - Parameter Predicate: With String Swift format only. Like "id == \(yourModel.id)"
    func get(Predicate:String) -> Ent? {
        return try? self.fetch(Predicate: Predicate).get().first
    }
    
    /// Delete the entity from its context
    /// - Parameter Entity: Entity to remove
    func delete(Entity: Ent) {
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
