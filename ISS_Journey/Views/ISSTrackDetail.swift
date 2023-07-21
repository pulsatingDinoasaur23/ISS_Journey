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
    var body: some View {
        NavigationView {
            VStack {
                List{
                    ForEach(issListVM.locations) { location in
                        Text(location.longitude! + ", " + location.latitude!)
                    }.onDelete(perform: deleteItem)
                }
            }.navigationTitle("Passed Locations" )
        }
        
    }
    struct ISSTrackDetail_Previews: PreviewProvider {
        static var previews: some View {
            let viewContext = CoreDataManager.shared.persistenseStoreContainer.viewContext
            ISSTrackDetail (vm: ISSListViewModel(context: viewContext))
        }
    }
}
