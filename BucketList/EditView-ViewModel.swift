//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Jakub Czerwiec  on 09/12/2024.
//

import Foundation

extension EditView {
    @Observable
    class EditViewModel {
        enum LoadingState {
            case loading, loaded, failed
        }
        var location: Location
        var pages = [Page]()
        
        var loadingState = LoadingState.loading
        
        var name: String
        var description: String
        
        func fetchNearbyPlaces () async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let items = try JSONDecoder().decode(Result.self, from: data)
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
        
        init(location: Location, loadingState: LoadingState = LoadingState.loading, name: String, description: String) {
            self.location = location
            self.loadingState = loadingState
            self.name = location.name
            self.description = location.description
        }
    }
}
