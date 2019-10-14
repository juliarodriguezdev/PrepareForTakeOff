//
//  CityList.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/7/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//
//struct CityResults: Codable {
//    let city: City
//}

struct City: Codable {

      var name: String
      var country: String
      var coordinates: Coord
    
    enum CodingKeys: String, CodingKey {
        case name
        case country
        case coordinates = "coord"
    }
}
  
struct Coord: Codable {
    let lon: Double
    let lat: Double
    
    enum CodingKeys: String, CodingKey {
        case lon
        case lat
    }
}

extension City: Equatable {
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.country == rhs.country
            && lhs.name == rhs.name
    }
    
    
}
