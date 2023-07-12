//
//  ISSViewModel.swift
//  ISS_Journey
//
//  Created by michaell medina on 09/07/23.
//

import Foundation
import Combine

class ISSViewModel: ObservableObject {
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    @Published var timestamp: Int = 0
    @Published var isTrackingEnabled: Bool = false

    private let apiClient: APIClient
    private let locationUseCase: LocationUseCase

    init(apiClient: APIClient, locationUseCase: LocationUseCase) {
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
            // Actualiza otras propiedades observables con los datos obtenidos
        }
    }

    func didFailToUpdateISSLocation(error: Error) {
        print("Error al obtener la ubicación de ISS: \(error)")
    }
}
