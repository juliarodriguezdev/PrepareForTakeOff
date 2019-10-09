//
//  LocationController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/7/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class TravelLocationController {
    
    static let shared = TravelLocationController()
    
    let usersLocale = Locale.current.localizedString(forCurrencyCode:)
    
    // source of truth
    var destinationLocation: [TravelLocation] = []
    
    
    // CRUD Funcs
    
    // Create
    func createDestinationLocation(location: TravelLocation) {
        
    }
    
    // Read
    
    // Update
    
    // Delete
}
