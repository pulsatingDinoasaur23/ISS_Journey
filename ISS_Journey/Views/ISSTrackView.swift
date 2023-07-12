//
//  ISSTrackView.swift
//  ISS_Journey
//
//  Created by michaell medina on 09/07/23.
//

import SwiftUI

struct ISSView: View {
    @ObservedObject private var viewModel: ISSViewModel

    init(viewModel: ISSViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text("Latitude: \(viewModel.latitude)")
            Text("Longitude: \(viewModel.longitude)")
            Text("Speed: \(viewModel.timestamp)")
            // Agrega otros componentes de la interfaz de usuario
        }
        .onAppear {
            viewModel.fetchISSLocation()
        }
    }
}
