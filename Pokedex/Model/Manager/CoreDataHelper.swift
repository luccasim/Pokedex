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
    
    associatedtype Entity : NSManagedObject
    
    func create() -> Entity
    func fetch(Predicate:String?) -> Result<[Entity],Error>
    func delete(Entity:Entity)
    func save()
    func clear()
    
}

extension CoreDataHelper {

    private var context : NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func create() -> Entity {
        return Entity(context: self.context)
    }
    
    func fetch(Predicate:String?=nil) -> Result<[Entity],Error> {
        
        let request = Entity.fetchRequest()
        
        if let predicate = Predicate {
            request.predicate = NSPredicate(format: predicate)
        }
        
        do {
            
            let result = try self.context.fetch(request) as? [Entity] ?? []
            return .success(result)
            
        } catch let error {
            return .failure(error)
        }
    }
    
    func delete(Entity: Entity) {
        self.context.delete(Entity)
    }
    
    func save() {
        try? self.context.save()
    }
    
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
