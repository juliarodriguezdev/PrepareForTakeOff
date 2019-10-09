//
//  Location.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/7/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation

class TravelLocation {
    // from json data 
    var city: String
    var stateCode: String?
    var countryCode: String
    var countryName: String
    var inUSA: Bool
    
    init(city: String, stateCode: String?, countryCode: String, countryName: String, inUSA: Bool) {
        self.city = city
        self.stateCode = stateCode
        self.countryCode = countryCode
        self.countryName = countryName
        self.inUSA = inUSA
    }
}
extension TravelLocation: Equatable {
    static func == (lhs: TravelLocation, rhs: TravelLocation) -> Bool {
        return lhs.city == rhs.city
            && lhs.countryCode == rhs.countryCode
    }
    
}
