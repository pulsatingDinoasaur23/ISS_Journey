//
//  CoreDataManager.swift
//  ISS_Journey
//
//  Created by michaell medina on 09/07/23.
//

import Foundation
import CoreData
import CoreLocation




class CoreDataManager {
    
    let persistenseStoreContainer: NSPersistentContainer
    static let shared = CoreDataManager()
    
    private init(){
        persistenseStoreContainer = NSPersistentContainer(name: "ISSEntity")
        persistenseStoreContainer.loadPersistentStores { description, error in
            if error != nil {
                print("hubo pedo")
            }
        }
    }
}

func saveISSEntityCD(context: NSManagedObjectContext, latitude: String, longitude: String, timestamp: Int32) {
    // Crea un nuevo objeto ISSEntityCD en el contexto
    let newISSEntity = ISSEntityCD(context: context)
    
    // Asigna los valores de los atributos
    newISSEntity.latitude = latitude
    newISSEntity.longitude = longitude
    newISSEntity.timestamp = timestamp
    
    // Guarda los cambios en Core Data
    do {
        try context.save()
        print("Objeto ISSEntityCD guardado correctamente.")
    } catch {
        print("Error al guardar el objeto ISSEntityCD: \(error)")
    }
}

