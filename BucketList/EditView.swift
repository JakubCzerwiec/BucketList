//
//  EditView.swift
//  BucketList
//
//  Created by Jakub Czerwiec  on 07/12/2024.
//

import SwiftUI

struct EditView: View {

    @Environment(\.dismiss) var dismiss

    var onSave: (Location) -> Void
    
    
    @State private var editViewModel = EditViewModel(location: Location(id: UUID(), name: "", description: "", latitude: 0.0, longitude: 0.0), name: "", description: "")
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $editViewModel.name)
                    TextField("Description", text: $editViewModel.description)
                }
                Section("Nearby...") {
                    switch editViewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                        
                    case .loaded:
                        ForEach(editViewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                        
                    case .failed:
                        Text("Please, try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save", action: saveButton)

                
            }
            .task {
                await editViewModel.fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        
 //       editViewModel.location = location
        self.onSave = onSave
        
        _editViewModel = State(initialValue: EditViewModel(location: location, name: "", description: ""))
    }
    

    
    func saveButton() {
        var newLocation = editViewModel.location
        newLocation.id = UUID()
        newLocation.name = editViewModel.name
        newLocation.description = editViewModel.description
        
        onSave(newLocation)
        dismiss()
    }
}

#Preview {
    EditView(location: .example) { _ in }
}
