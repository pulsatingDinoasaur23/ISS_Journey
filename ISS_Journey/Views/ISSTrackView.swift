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
    @StateObject private var viewListModel: ISSListViewModel
    @State private var isTrackingEnabled = false
    @State private var isPresented: Bool = false

    init(viewModel: ISSViewModel, viewListModel: ISSListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _viewListModel = StateObject(wrappedValue: viewListModel)
    }

    var body: some View {
        NavigationView {
            VStack {
                MapView(coordinate: CLLocationCoordinate2D(latitude: Double(viewModel.latitude) ?? 0, longitude: Double(viewModel.longitude) ?? 0))
                    .frame(height: 300)
                    .cornerRadius(10)
                    .padding()

                Text("Latitude: \(viewModel.latitude)")
                Text("Longitude: \(viewModel.longitude)")
                Text("Timestamp: \(viewModel.timestamp)")

                Toggle("Track Location", isOn: $isTrackingEnabled)
                    .padding()
            }
            .navigationTitle("Track ISS")
            .navigationBarItems(trailing: menuButton) // Add the menu button to the leading side
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
        .sheet(isPresented: $isPresented, onDismiss: {
            // Code to run when the sheet is dismissed
        }, content: {
            ISSTrackDetail(vm: viewListModel)
        })
    }

    // Create the menu button
    var menuButton: some View {
        Menu {
            Button("Go To Locations") {
                isPresented = true
            }
            Button("Option 2") {
                // Add action for Option 2
            }
        } label: {
            Image(systemName: "line.horizontal.3") // Replace this with the image you want for the menu icon
                .imageScale(.large)
        }
    }
}
