import Foundation
import SwiftUI
import Combine
import CoreLocation
import CoreData

protocol ISSViewModelProtocol: AnyObject {
    var latitude: String { get }
    var longitude: String { get }
    var timestamp: Int { get }
    var isTrackingEnabled: Bool { get set }
    var currentSpeed: CLLocationSpeed? { get }
    
    func startTrackingLocation()
    func stopTrackingLocation()
    func fetchISSLocation()
}

class ISSViewModel: ISSViewModelProtocol, ObservableObject {
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    @Published var timestamp: Int = 0
    @Published var isTrackingEnabled: Bool = false
    @Published var currentSpeed: CLLocationSpeed? = nil

    private let apiClient: APIClientProtocol
    private var locationUseCase: LocationUseCaseProtocol
    private let context: NSManagedObjectContext
    private let distanceCalculator: DistanceCalculatorProtocol
    

    init(apiClient: APIClientProtocol, locationUseCase: LocationUseCaseProtocol, context: NSManagedObjectContext) {
        self.apiClient = apiClient
        self.locationUseCase = locationUseCase
        self.context = context
        self.distanceCalculator = DistanceCalculator()
        self.locationUseCase.delegate = self
    }


    func startTrackingLocation() {
        locationUseCase.startUpdatingLocation()
        updatePreviousPosition() 
    }


    func stopTrackingLocation() {
        locationUseCase.stopUpdatingLocation()
    }

    func fetchISSLocation() {
        if isTrackingEnabled {
            locationUseCase.startUpdatingLocation()
        }
    }
    
    private func generatePreviousPosition() -> Position? {
        let distanceCalculator = DistanceCalculator()
        return distanceCalculator.generatePreviousPosition(context: context)
    }

    
    func updatePreviousPosition() {
        if let previousPosition = generatePreviousPosition() {
            previousPosition.calculateSpeedAndCourse(previousPosition: nil)
            DispatchQueue.main.async {
                self.currentSpeed = previousPosition.speed
                
            }
        }
    }
}

extension ISSViewModel: LocationUseCaseDelegate {
    
    func didFailToUpdateISSLocation(error: Error) {
        print("Error al obtener la ubicación de ISS: \(error)")
    }
    
    func didUpdateISSLocation(latitude: Double, longitude: Double) {
        DispatchQueue.main.async { [self] in
            self.latitude = String(latitude)
            self.longitude = String(longitude)
            
            if let speed = self.currentSpeed {
                self.timestamp = Int(speed)
            } else {
                self.timestamp = 0 // Valor predeterminado si no hay velocidad actual
            }
            
            // Actualiza otras propiedades observables con los datos obtenidos
        }
    }

}
