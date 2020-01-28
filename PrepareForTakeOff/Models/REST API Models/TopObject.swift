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

struct TopObject: Codable {

    var city: CityObject
    
    enum CodingKeys: String, CodingKey {
        case city
    }
}

struct CityObject: Codable {
    
    var cityID: ID
    let name: String
    var country: String
    //var coordinates: Coord
    
    enum CodingKeys: String, CodingKey {
        case cityID = "id"
        case name
        case country
        //case coordinates = "coord"
    }
}

struct ID: Codable {
    var numberLong: String
    
    enum CodingKeys: String, CodingKey {
        case numberLong = "$numberLong"
    }
}
//struct Coord: Codable {
//    var lon: Double?
//    var lat: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case lon
//        case lat
//    }
//}

struct City: Equatable {
    let name: String
    let cityID: String
    let country: String
    //let lat: Double
   // let lon: Double
    
    init(_ jsonObject: CityObject) {
        self.name = jsonObject.name
        self.cityID = jsonObject.cityID.numberLong
        self.country = jsonObject.country
       // self.lat = jsonObject.coordinates.lat ?? 0
       // self.lon = jsonObject.coordinates.lon ?? 0
    }
}
