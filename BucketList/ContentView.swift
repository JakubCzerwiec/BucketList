//
//  ContentView.swift
//  BucketList
//
//  Created by Jakub Czerwiec  on 06/12/2024.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
        
    @State private var viewModel = ViewModel()
    var body: some View {
        if viewModel.isUnlocked {
                MapReader { proxy in   // This allows to read coordniates of a map, no screen
                    ZStack {
                        Map(initialPosition: startPosition) {
                            
                            ForEach(viewModel.locations) { location in
                                Annotation(location.name, coordinate: location.coordinate) {
                                    Image(systemName: "star.circle")
                                        .resizable()
                                        .foregroundStyle(.red)
                                        .frame(width: 44, height: 44)
                                        .background(.white)
                                        .clipShape(.circle)
                                        .onLongPressGesture {
                                            viewModel.selectedPlace = location
                                        }
                                }
                            }
                        }
                        VStack {
                            HStack {
                                Spacer()
                                Button("", systemImage: "map.fill") {
                                    viewModel.mapStylePicker.toggle()
                                }
                                    .padding()
                                    .foregroundStyle(.gray)
                                    .font(.title)
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .background(Color(red: 0.25, green: 0.25, blue: 0.25))
                                    .cornerRadius(5.0)
                            }
                            .padding()
                            Spacer()
                        }
                    }
                    .mapStyle(viewModel.mapStyle ? .hybrid : .standard)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) {
                            viewModel.update(location: $0)
                        }
                    }
                    .confirmationDialog("Select map type", isPresented: $viewModel.mapStylePicker) {
                        Button("Standard") { viewModel.mapStyle = false }
                        Button("Hybrid") { viewModel.mapStyle = true }
                    }

            }
        } else {
            Button("Unlock places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
                .alert("Authentication unsuccessful", isPresented: $viewModel.authenticationAlert) {
                    Button("OK", role: .cancel) { }
                }
        }
        
    }
        
}

#Preview {
    ContentView()
}
