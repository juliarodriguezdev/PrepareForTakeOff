//
//  Trip.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/7/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation

class Trip {
    
    var date: Date
    var name: String
    var location: TravelLocation
    var currencyCodes: CurrencyExchangeCodes
    
    init(date: Date, name: String, location: TravelLocation, currencyCodes: CurrencyExchangeCodes) {
        self.date = date
        self.name = name
        self.location = location
        self.currencyCodes = currencyCodes
    }
    
}
extension Trip: Equatable {
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        return lhs.date == rhs.date
            && lhs.name == rhs.name
            && lhs.location == rhs.location
    }
    
    
}
