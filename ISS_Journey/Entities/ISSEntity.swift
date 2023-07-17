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
    var timestamp: TimeInterval
    
    init(latitude: Double, longitude: Double, speed: CLLocationSpeed? = nil, timestamp: TimeInterval, course: CLLocationDirection? = nil) throws {
        self.latitude = latitude
        self.longitude = longitude
        self.speed = speed
        self.timestamp = timestamp
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
    
    func calculateSpeedAndCourse(previousPosition: Position?) -> CLLocationSpeed? {
        guard let previousPosition = previousPosition else { return nil }
        
        let previousLocation = CLLocation(latitude: previousPosition.latitude, longitude: previousPosition.longitude)
        let currentLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        
        let distance = currentLocation.distance(from: previousLocation)
        let timeInterval = self.timestamp - previousPosition.timestamp
        
        guard distance > 0 && timeInterval > 0 else { return nil }
        
        let speed = distance / timeInterval
        
        return speed
    }
    
    enum ValidationError: Error {
        case invalidLatitude
        case invalidLongitude
    }
}
