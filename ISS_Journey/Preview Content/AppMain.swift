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
    private let context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "YourDataModelName")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container.viewContext
    }()
    
    private let apiClient: APIClientProtocol = APIClient()
    private var locationUseCase: LocationUseCaseProtocol {
        LocationUseCase(apiClient: apiClient)
    }
    private var viewModel: ISSViewModelProtocol {
        ISSViewModel(apiClient: apiClient, locationUseCase: locationUseCase, context: context)
    }

    var body: some Scene {
        WindowGroup {
            ISSView(viewModel: viewModel as! ISSViewModel)
                .environment(\.managedObjectContext, context)
        }
    }
}
