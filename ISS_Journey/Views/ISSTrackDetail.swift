//
//  ISSTrackDetail.swift
//  ISS_Journey
//
//  Created by michaell medina on 20/07/23.
//

import SwiftUI

struct ISSTrackDetail: View {
        @State private var isPresented: Bool = false
        @State private var isNavigatingToSecondaryView: Bool = false

    @Environment (\ .managedObjectContext) var viewContext
    
    @ObservedObject  private var issListVM: ISSListViewModel
    
    init (vm: ISSListViewModel) {
        self.issListVM = vm
    }
    
    private func deleteItem(at offsets: IndexSet) {
        offsets.forEach { index in
            let location = issListVM.locations[index]
            issListVM.deleteLocation(budgetId: location.id)

        }
         
    }
    func clearAllLocations() {
        // Obtiene los NSManagedObjectID de todas las ubicaciones en issListVM.locations
        let locationObjectIDs = issListVM.locations.map { $0.id }

        // Elimina todas las ubicaciones de Core Data una por una
        for objectID in locationObjectIDs {
            issListVM.deleteLocation(budgetId: objectID)
        }

        // Limpia el arreglo de ubicaciones en issListVM después de eliminarlos de Core Data
        issListVM.locations.removeAll()
    }

    var body: some View {
            NavigationView {
                VStack {
                    List {
                        ForEach(issListVM.locations) { location in
                            Text(location.longitude! + ", " + location.latitude!)
                        }
                        .onDelete(perform: deleteItem)
                    }

                    // Agregar el botón "Borrar Todo"
                    Button("Borrar Todo", action: clearAllLocations)
                        .foregroundColor(.red)
                        .padding(.vertical)
                }
                .navigationTitle("Passed Locations")
            }
        }
    
    struct ISSTrackDetail_Previews: PreviewProvider {
        static var previews: some View {
            let viewContext = CoreDataManager.shared.persistenseStoreContainer.viewContext
            ISSTrackDetail (vm: ISSListViewModel(context: viewContext))
        }
    }
}
