import Foundation
import CoreLocation
import CoreData

class ISSEntity: NSManagedObject {
    var position: Position?
    @NSManaged var message: String?
    @NSManaged var timestamp: TimeInterval
    
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "ISSEntityCD", in: context)!
        self.init(entity: entityDescription, insertInto: context)
    }
}

extension ISSEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ISSEntityCD> {
        return NSFetchRequest<ISSEntityCD>(entityName: "ISSEntityCD")
    }
}

class Position: Codable {
    var latitude: Double
    var longitude: Double
    var timestamp: TimeInterval
    
    init(latitude: Double, longitude: Double, timestamp: TimeInterval) throws {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp

        
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
    
    enum ValidationError: Error {
        case invalidLatitude
        case invalidLongitude
    }
}
