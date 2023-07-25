//
//  ISSListViewModel.swift
//  ISS_Journey
//
//  Created by michaell medina on 20/07/23.
//

import Foundation
import CoreData

class ISSListViewModel: NSObject, ObservableObject {
    @Published var locations = [ISSListModel]()
    private var fetchedResultsController: NSFetchedResultsController<ISSEntityCD>
    private (set) var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let fetchRequest: NSFetchRequest<ISSEntityCD> = ISSEntityCD.fetchRequest()
        
        // Agregar el sort descriptor para ordenar por 'latitude' en orden ascendente
        let sortDescriptor = NSSortDescriptor(key: "latitude", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
                return
            }
            self.locations = fetchedObjects.map(ISSListModel.init)
        } catch {
            print(error)
        }
        do {
            try fetchedResultsController.performFetch()
            guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
                return
            }
            self.locations = fetchedObjects.map(ISSListModel.init)
        } catch {
            print(error)
        }
    }
    
    func deleteLocation(budgetId: NSManagedObjectID) {
        do {
            let location = try context.existingObject(with: budgetId) as? ISSEntityCD
            if let locationToDelete = location {
                context.delete(locationToDelete)
                try context.save()
            }
        } catch {
            print(error)
        }
    }
}

extension ISSListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Agregar el sort descriptor para ordenar por 'latitude' en orden ascendente
        let sortDescriptor = NSSortDescriptor(key: "latitude", ascending: true)
        fetchedResultsController.fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            try fetchedResultsController.performFetch()
            guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
                return
            }
            self.locations = fetchedObjects.map(ISSListModel.init)
        } catch {
            print(error)
        }
    }
}


struct ISSListModel: Identifiable {
    private var locations: ISSEntityCD
    
    init(locations: ISSEntityCD) {
        self.locations = locations
    }
    
    var id: NSManagedObjectID {
        locations.objectID
    }
    
    var latitude: String? {
        locations.latitude
    }
    
    var longitude: String? {
        locations.longitude
    }
}
