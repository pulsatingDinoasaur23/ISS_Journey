import Foundation
import SwiftUI
import Combine
import CoreLocation
import CoreData

protocol ISSViewModelProtocol: AnyObject {
    var latitude: String { get }
    var longitude: String { get }
    var timestamp: Int32 { get }
    var isTrackingEnabled: Bool { get set }
    
    func startTrackingLocation()
    func stopTrackingLocation()
    func fetchISSLocation()
    
}

class ISSViewModel: ISSViewModelProtocol, ObservableObject {
   
    
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    @Published var timestamp: Int32 = 0
    @Published var isTrackingEnabled: Bool = false
    
    private let apiClient: APIClientProtocol
    private var locationUseCase: LocationUseCaseProtocol
    private let context: NSManagedObjectContext
    
    
    
    init(apiClient: APIClientProtocol, locationUseCase: LocationUseCaseProtocol, context: NSManagedObjectContext) {
        self.apiClient = apiClient
        self.locationUseCase = locationUseCase
        self.context = context
        self.locationUseCase.delegate = self
    }
    
    
    func startTrackingLocation() {
        locationUseCase.startUpdatingLocation()
        
        
    }
    
    
    func stopTrackingLocation() {
        locationUseCase.stopUpdatingLocation()
    }
    
    func fetchISSLocation() {
        if isTrackingEnabled {
            locationUseCase.startUpdatingLocation()
        }
    }
}

extension ISSViewModel: LocationUseCaseDelegate {
    
    func didFailToUpdateISSLocation(error: Error) {
        print("Error al obtener la ubicación de ISS: \(error)")
    }
    
    func didUpdateISSLocation(latitude: String, longitude: String, timestamp: Int32) {
        DispatchQueue.main.async { [self] in
            self.latitude = String(latitude)
            self.longitude = String(longitude)
            self.timestamp = Int32((timestamp))
            
            saveISSEntityCD(context: context, latitude: latitude, longitude: longitude, timestamp: timestamp)
            // Actualiza otras propiedades observables con los datos obtenidos
        }
    }

}
