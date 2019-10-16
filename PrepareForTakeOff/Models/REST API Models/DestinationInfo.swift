//
//  LocationInfo.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/7/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

struct TopLevelJSON: Codable {
    let results: [DestinationInfo]
}

struct DestinationInfo: Codable {
    let name: String
    let country: String
    let coordinates: Coordinates
    let snippet: String
    let score: Double
    let images: [Images?]
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case country = "country_id"
        case coordinates
        case snippet
        case score
        case images
        case type
    }
    
}

struct Coordinates: Codable {
    let latitude: Double?
    let longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}

struct Images: Codable {
    let sizes: Sizes
    
    enum CodingKeys: String, CodingKey {
        case sizes
    }
}

struct Sizes: Codable {
    let medium: Medium
    
    enum CodingKeys: String, CodingKey {
        case medium
    }
}

struct Medium: Codable {
    let urlAsString: String
    
    enum CodingKeys: String, CodingKey {
        case urlAsString = "url"
    }
}
