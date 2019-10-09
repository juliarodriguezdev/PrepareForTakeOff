//
//  PointOfInterest.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/7/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

struct PoingOfInterestTopLevelJSON: Codable {
    let results: [PointOfInterest]
}

struct PointOfInterest: Codable {
    let name: String
    let coordinates: Coordinates
    let snippet: String
    let images: [Images]?
    let score: String
    // where is this at 
    let locationID: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case coordinates
        case snippet
        case images
        case score
        case locationID = "location_id"
    }
}

