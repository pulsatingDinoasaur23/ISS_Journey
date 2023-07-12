//
//  AppMain.swift
//  ISS_Journey
//
//  Created by michaell medina on 09/07/23.
//

import SwiftUI

@main
struct ISSApp: App {
    private let locationUseCase: LocationUseCase
    private let viewModel: ISSViewModel

    init() {
        // Inicializa el locationUseCase
        let apiClient = APIClient()
        locationUseCase = LocationUseCase(apiClient: apiClient)
        
        // Inicializa el viewModel con el locationUseCase
        viewModel = ISSViewModel(apiClient: apiClient, locationUseCase: locationUseCase)
    }
    
    var body: some Scene {
        WindowGroup {
            ISSView(viewModel: viewModel)
        }
    }
}
