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
    
    init() {
        persistentContainer = NSPersistentContainer(name: "ISS_Journey") // Reemplaza "YourDataModel" con el nombre de tu modelo de datos en CoreData
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
            
            issEntity.setValue(latitude, forKey: "latitude")
            issEntity.setValue(longitude, forKey: "longitude")
            issEntity.setValue(speed, forKey: "speed")
            issEntity.setValue(direction, forKey: "direction")
            
            do {
                try context.save()
            } catch {
                print("Error al guardar los datos de ISS en Core Data: \(error)")
            }
        }
    }

}
