//
//  Result.swift
//  BucketList
//
//  Created by Jakub Czerwiec  on 08/12/2024.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    var pages: [Int: Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    var description: String {
        terms?["description"]?.first ?? "No further information."
    }
    
    static func <(lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
