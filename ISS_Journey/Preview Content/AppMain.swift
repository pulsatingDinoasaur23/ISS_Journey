//
//  AppMain.swift
//  ISS_Journey
//
//  Created by michaell medina on 09/07/23.
//

import SwiftUI
import CoreData

@main
struct ISSApp: App {
    var context: NSManagedObjectContext

    init() {
        // Obtener el contexto de CoreData
        context = CoreDataManager.shared.persistenseStoreContainer.viewContext
    }
    
    var body: some Scene {
        WindowGroup {
            let apiClient: APIClientProtocol = APIClient()
            var locationUseCase: LocationUseCaseProtocol = LocationUseCase(apiClient: apiClient)
            let viewContext = CoreDataManager.shared.persistenseStoreContainer.viewContext
            
            let issViewModel = ISSViewModel(apiClient: apiClient, locationUseCase: locationUseCase, context: viewContext)
            let issListViewModel = ISSListViewModel(context: viewContext)
            
            ISSView(viewModel: issViewModel, viewListModel: issListViewModel)
        }
    }
}
