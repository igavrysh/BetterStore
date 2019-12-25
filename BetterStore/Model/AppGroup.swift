//
//  AppGroup.swift
//  BetterStore
//
//  Created by new on 12/25/19.
//  Copyright © 2019 Ievgen Gavrysh. All rights reserved.
//

import Foundation

struct AppGroup: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Decodable {
    let name, artistName, artworkUrl100: String
}
