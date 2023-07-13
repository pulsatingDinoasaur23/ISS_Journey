//
//  ISSTrackView.swift
//  ISS_Journey
//
//  Created by michaell medina on 09/07/23.
//


import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        view.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000000, longitudinalMeters: 5000000)
        view.setRegion(region, animated: true)
    }
}

struct ISSView: View {
    @StateObject private var viewModel: ISSViewModel
    @State private var isTrackingEnabled = false

    init(viewModel: ISSViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            MapView(coordinate: CLLocationCoordinate2D(latitude: Double(viewModel.latitude) ?? 0, longitude: Double(viewModel.longitude) ?? 0))
                .frame(height: 300)
                .cornerRadius(10)
                .padding()

            Text("Latitude: \(viewModel.latitude)")
            Text("Longitude: \(viewModel.longitude)")
            Text("Speed: \(viewModel.timestamp)")

            Toggle("Track Location", isOn: $isTrackingEnabled)
                .padding()

        }
        .onAppear {
            viewModel.fetchISSLocation()
        }
        .onChange(of: isTrackingEnabled) { enabled in
            if enabled {
                viewModel.startTrackingLocation()
            } else {
                viewModel.stopTrackingLocation()
            }
        }
    }
}
