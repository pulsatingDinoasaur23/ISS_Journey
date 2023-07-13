//
//  ISSViewModel.swift
//  ISS_Journey
//
//  Created by michaell medina on 09/07/23.
//

import Foundation
import Combine

protocol ISSViewModelProtocol: AnyObject {
    var latitude: String { get }
    var longitude: String { get }
    var timestamp: Int { get }
    var isTrackingEnabled: Bool { get set }
    
    func startTrackingLocation()
    func stopTrackingLocation()
    func fetchISSLocation()
}

class ISSViewModel: ISSViewModelProtocol, ObservableObject {
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    @Published var timestamp: Int = 0
    @Published var isTrackingEnabled: Bool = false

    private let apiClient: APIClientProtocol
    private var locationUseCase: LocationUseCaseProtocol

    init(apiClient: APIClient, locationUseCase: LocationUseCaseProtocol) {
        self.apiClient = apiClient
        self.locationUseCase = locationUseCase
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
    func didUpdateISSLocation(latitude: Double, longitude: Double) {
        DispatchQueue.main.async {
            self.latitude = String(latitude)
            self.longitude = String(longitude)
            self.timestamp = Int()
            // Update other observable properties with the obtained data
        }
    }

    func didFailToUpdateISSLocation(error: Error) {
        print("Error al obtener la ubicación de ISS: \(error)")
    }
}
