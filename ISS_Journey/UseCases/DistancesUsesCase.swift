//
//  DistancesUsesCase.swift
//  ISS_Journey
//
//  Created by michaell medina on 13/07/23.
//

import Foundation
import CoreLocation
import CoreData

protocol DistanceCalculatorProtocol {
    func calculateDistance(from source: Position, to destination: Position) -> CLLocationDistance
    func generatePreviousPosition(context: NSManagedObjectContext) -> Position?
}

class DistanceCalculator: DistanceCalculatorProtocol {
    let coreDataStack = CoreDataStack.shared

    func calculateDistance(from source: Position, to destination: Position) -> CLLocationDistance {
        let sourceLocation = CLLocation(latitude: source.latitude, longitude: source.longitude)
        let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        return sourceLocation.distance(from: destinationLocation)
    }

    func generatePreviousPosition(context: NSManagedObjectContext) -> Position? {
        let fetchRequest: NSFetchRequest<ISSEntityCD> = ISSEntityCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "timestamp < %@", NSDate())
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            if let entity = results.first {
                let timestamp = entity.timestamp // Obtén el valor del timestamp desde ISSEntity
                let latitude = Double(entity.latitude ?? "0.0") ?? 0.0
                let longitude = Double(entity.longitude ?? "0.0") ?? 0.0
                let previousPosition = try Position(latitude: latitude, longitude: longitude, timestamp: TimeInterval(timestamp))
                previousPosition.calculateSpeedAndCourse(previousPosition: nil)
                return previousPosition
            }
        } catch {
            print("Error al obtener la posición anterior de Core Data: \(error)")
        }
        
        return nil
    }
}
