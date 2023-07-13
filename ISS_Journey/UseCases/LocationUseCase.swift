//
//  LocationUseCase.swift
//  ISS_Journey
//
//  Created by michaell medina on 12/07/23.
//

import Foundation

protocol LocationUseCaseDelegate: AnyObject {
    func didUpdateISSLocation(latitude: Double, longitude: Double)
    func didFailToUpdateISSLocation(error: Error)
}
protocol LocationUseCaseProtocol{
    var delegate: LocationUseCaseDelegate? { get set }
   func startUpdatingLocation()
    func stopUpdatingLocation()
    func fetchISSLocation() -> Void
}

class LocationUseCase: LocationUseCaseProtocol {
    private let apiClient: APIClientProtocol
    private let updateInterval: TimeInterval = 10 // Actualización cada 10 segundos
    private var timer: Timer?
    weak var delegate: LocationUseCaseDelegate?
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func startUpdatingLocation() {
        stopUpdatingLocation()
        
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.fetchISSLocation()
        }
        
        fetchISSLocation()
    }
    
    func stopUpdatingLocation() {
        timer?.invalidate()
        timer = nil
    }
    
    internal func fetchISSLocation() {
        apiClient.fetchISSLocation { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let issData):
                if let latitude = Double(issData.issPosition.latitude),
                   let longitude = Double(issData.issPosition.longitude)
                {
                    self.delegate?.didUpdateISSLocation(latitude: latitude, longitude: longitude)
                }
            case .failure(let error):
                self.delegate?.didFailToUpdateISSLocation(error: error)
            }
        }
    }
    
    deinit {
        stopUpdatingLocation()
    }
}
