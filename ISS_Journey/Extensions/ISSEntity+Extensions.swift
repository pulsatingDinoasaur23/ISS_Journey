//
//  ISSEntity+Extensions.swift
//  ISS_Journey
//
//  Created by michaell medina on 20/07/23.
//

import Foundation
import CoreData

extension ISSEntity: BaseModel {
    static var all: NSFetchRequest<ISSEntityCD> {
        let request = ISSEntityCD.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true)] // Agrega un descriptor de ordenamiento basado en el atributo 'latitude'
        return request
    }
}
