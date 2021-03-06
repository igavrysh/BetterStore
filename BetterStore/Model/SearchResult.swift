//
//  SearchResult.swift
//  BetterStore
//
//  Created by new on 12/24/19.
//  Copyright © 2019 Ievgen Gavrysh. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Decodable {
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    let averageUserRating: Float?
    let screenshotUrls: [String]?
    let artworkUrl100: String
    var formattedPrice: String?
    let description: String?
    let releaseNotes: String?
    var artistName: String?
    var collectionName: String?
}
