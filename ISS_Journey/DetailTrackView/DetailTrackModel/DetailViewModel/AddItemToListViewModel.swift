//
//  AddItemToListViewModel.swift
//  ISS_Journey
//
//  Created by michaell medina on 20/07/23.
//

import Foundation
import CoreData

class AddItemViewModel: ObservableObject{
    
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    @Published var timestamp: Int32 = 0
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
     
    func save() {
        
        do{
            let location = ISSEntityCD(context: context)
            location.latitude = latitude
            location.longitude = longitude
            location.timestamp = timestamp
            try context.save()
        } catch {
            print(error)
    }
}
}
 
