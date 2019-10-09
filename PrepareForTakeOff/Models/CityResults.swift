//
//  CityList.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/7/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//
struct CityResults: Decodable {
    let cities: [City]
}

struct City: Decodable {

      var name: String
      var country: String
      var coordinates: Coord
    
    enum CodingKeys: String, CodingKey {
        case name
        case country
        case coordinates = "coord"
    }
}
  
struct Coord: Decodable {
    let lon: Double
    let lat: Double
    
    enum CodingKeys: String, CodingKey {
        case lon
        case lat
    }
}
