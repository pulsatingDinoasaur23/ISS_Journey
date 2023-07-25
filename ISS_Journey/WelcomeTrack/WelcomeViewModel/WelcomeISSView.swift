//
//  WelcomeISSView.swift
//  ISS_Journey
//
//  Created by michaell medina on 25/07/23.
//

import SwiftUI

struct HomeView: View {
    var apiClient: APIClientProtocol = APIClient()
    var locationUseCase: LocationUseCaseProtocol
    
    init() {
        // Puedes inicializar locationUseCase aquí
        locationUseCase = LocationUseCase(apiClient: apiClient)
    }
    
    var body: some View {
        let issViewModel = ISSViewModel(apiClient: apiClient, locationUseCase: locationUseCase, context: CoreDataManager.shared.persistenseStoreContainer.viewContext)
        let issListViewModel = ISSListViewModel(context: CoreDataManager.shared.persistenseStoreContainer.viewContext)
        
        return VStack(spacing: 20) {
            Text("ISS Tracker APP")
                .font(.largeTitle)
                .fontWeight(.bold)

            Image("ISSIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200) 
            
            Text("Descubre el asombroso mundo de la exploración espacial con nuestra aplicación ISS Tracker. Sigue los pasos de la Estación Espacial Internacional mientras orbita la Tierra. ISS Tracker te brinda una vista en tiempo real de la ISS en su trayectoria y te permite conocer su ubicación precisa en cualquier momento.")
                .font(.headline)
            
            NavigationLink(destination: ISSView(viewModel: issViewModel, viewListModel: issListViewModel)) {
                Text("Comenzar Viaje")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
