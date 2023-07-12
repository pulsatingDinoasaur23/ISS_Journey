//
//  AppMain.swift
//  ISS_Journey
//
//  Created by michaell medina on 09/07/23.
//

import SwiftUI

@main
struct ISSApp: App {
    let viewModel = ISSViewModel(apiClient: APIClient())

    var body: some Scene {
        WindowGroup {
            ISSView(viewModel: viewModel)
        }
    }
}
