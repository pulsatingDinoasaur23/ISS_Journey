//
//  AppMain.swift
//  ISS_Journey
//
//  Created by michaell medina on 09/07/23.
//

import SwiftUI

@main
struct ISSApp: App {
    private let locationUseCase: LocationUseCaseProtocol
    private let viewModel: ISSViewModelProtocol

    init() {
        // Inicializa el locationUseCase con una instancia de LocationUseCase que implementa el protocolo
        let apiClient: APIClientProtocol = APIClient()
        locationUseCase = LocationUseCase(apiClient: apiClient)
        
        // Inicializa el viewModel con el locationUseCase
        viewModel = ISSViewModel(apiClient: apiClient as! APIClient, locationUseCase: locationUseCase)
    }
    
    var body: some Scene {
        let apiClient: APIClientProtocol = APIClient()
        let locationUseCase: LocationUseCaseProtocol = LocationUseCase(apiClient: apiClient)
        let viewModel: ISSViewModelProtocol = ISSViewModel(apiClient: apiClient as! APIClient, locationUseCase: locationUseCase)
        
        return WindowGroup {
            ISSView(viewModel: viewModel as! ISSViewModel)
        }
    }

    }
