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
    static let shared = CoreDataManager()
        
        private let persistentContainer: NSPersistentContainer
        let timestamp: TimeInterval = Date().timeIntervalSince1970

    
    private init() {
        persistentContainer = NSPersistentContainer(name: "ISSEntity") // Reemplaza "ISSEntity" con el nombre de tu modelo de datos en CoreData
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to initialize CoreData: \(error)")
            }
        }
    }
    
    func saveISSData(latitude: Double, longitude: Double, speed: CLLocationSpeed, direction: CLLocationDirection) {
        let context = persistentContainer.viewContext
        
        context.perform {
            let issEntity = ISSEntity(context: context)
            
            do {
                let position = try Position(latitude: latitude, longitude: longitude, speed: speed, timestamp: self.timestamp)
                issEntity.position = position
            } catch {
                print("Error al crear la posición de ISS: \(error)")
            }
            
            do {
                try context.save()
            } catch {
                print("Error al guardar los datos de ISS en Core Data: \(error)")
            }
        }
    }

}
