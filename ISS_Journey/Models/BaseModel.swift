//
//  BaseModel.swift
//  ISS_Journey
//
//  Created by michaell medina on 20/07/23.
//

import Foundation
import CoreData

protocol BaseModel {
    static var viewContext: NSManagedObjectContext { get }
    func save() throws
    func delete() throws
    
}
extension BaseModel where Self: NSManagedObject {
    
    static var viewContext: NSManagedObjectContext{
        CoreDataManager.shared.persistenseStoreContainer.viewContext
        
    }
    
    func save() throws {
        try Self.viewContext.save()
    }
    
    func delete() throws{
        Self.viewContext.delete(self)
        try save()
        
    }
}

