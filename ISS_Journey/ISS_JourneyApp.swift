//
//  ISS_JourneyApp.swift
//  ISS_Journey
//
//  Created by michaell medina on 08/07/23.
//

import SwiftUI

@main
struct ISS_JourneyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
