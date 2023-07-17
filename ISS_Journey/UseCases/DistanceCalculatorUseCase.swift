//
//  DistanceCalculatorUseCase.swift
//  ISS_Journey
//
//  Created by michaell medina on 13/07/23.
//

import Foundation
import MapKit
import CoreData

class DistanceCalculator {
    static func calculateDistance(from source: Position, to destination: Position) -> CLLocationDistance {
        let sourceLocation = CLLocation(latitude: source.latitude, longitude: source.longitude)
        let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        return sourceLocation.distance(from: destinationLocation)
    }
    
    static func generatePreviousPosition(context: NSManagedObjectContext) -> Position? {
      
        let fetchRequest: NSFetchRequest<ISSEntity> = ISSEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            if let entity = results.first {
                // Utiliza los atributos de la entidad para generar la posición anterior
                let previousPosition = Position(latitude: entity.latitude, longitude: entity.longitude)
                return previousPosition
            }
        } catch {
            print("Error al obtener la posición anterior de Core Data: \(error)")
        }
        
        return nil
    }
}
