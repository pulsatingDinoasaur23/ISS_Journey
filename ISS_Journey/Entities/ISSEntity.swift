import Foundation
import CoreLocation
import CoreData

class ISSEntity: NSManagedObject {
    var position: Position?
    @NSManaged var message: String?
    @NSManaged var timestamp: TimeInterval
    
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "ISSEntity", in: context)!
        self.init(entity: entityDescription, insertInto: context)
    }
}

extension ISSEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ISSEntity> {
        return NSFetchRequest<ISSEntity>(entityName: "ISSEntity")
    }
}

class Position: Codable {
    var latitude: Double
    var longitude: Double
    var speed: CLLocationSpeed?
    var course: CLLocationDirection?
    
    init(latitude: Double, longitude: Double, speed: CLLocationSpeed? = nil, course: CLLocationDirection? = nil) throws {
        self.latitude = latitude
        self.longitude = longitude
        self.speed = speed
        self.course = course
        
        try validate(latitude: latitude, longitude: longitude)
    }
    
    private func validate(latitude: Double, longitude: Double) throws {
        guard latitude >= -90 && latitude <= 90 else {
            throw ValidationError.invalidLatitude
        }
        
        guard longitude >= -180 && longitude <= 180 else {
            throw ValidationError.invalidLongitude
        }
    }
    
    func calculateSpeedAndCourse(previousPosition: Position?) {
        guard let previousPosition = previousPosition else { return }
        
        let previousLocation = CLLocation(latitude: previousPosition.latitude, longitude: previousPosition.longitude)
        let currentLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        
        let distance = currentLocation.distance(from: previousLocation)
        let timeInterval = 1.0 // Unidad de tiempo en segundos
        
        let speed = distance / timeInterval
        
        self.speed = speed
        
        if distance > 0 {
            let direction = atan2(currentLocation.coordinate.latitude - previousLocation.coordinate.latitude, currentLocation.coordinate.longitude - previousLocation.coordinate.longitude)
            self.course = direction * 180.0 / .pi
        } else {
            self.course = nil
        }
    }
}

enum ValidationError: Error {
    case invalidLatitude
    case invalidLongitude
}
