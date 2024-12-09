//
//  Location.swift
//  BucketList
//
//  Created by Jakub Czerwiec  on 07/12/2024.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    #if DEBUG // it want be deployed to appstore, only for XCode preview
    static let example = Location(id: UUID(), name: "Buckingam Palace", description: "Lit by 40,000 lightbulp", latitude: 52.501, longitude: -0.141)
    #endif
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
