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
    

    private let apiClient: APIClient 

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchISSLocation() {
        apiClient.fetchISSLocation { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let issData):
                DispatchQueue.main.async {
                    self.latitude = issData.issPosition.latitude
                    self.longitude = issData.issPosition.longitude
                    self.timestamp = issData.timestamp
                    // Actualiza otras propiedades observables con los datos obtenidos
                }
            case .failure(let error):
                print("Error al obtener la ubicación de ISS: \(error)")
            }
        }
    }
}
