//
//  CurrencyExchangeCodesController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/8/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation

class CurrencyExchangeCodesController {
    
    static let shared = CurrencyExchangeCodesController()
    
    var apiSearchQuery: String = ""
    
    // CRUD
    
    // Create
    func createAPIsearchQuery(currentCurrencyCode: String, destinationCurrencyCode: String) {
        let newSearch = "\(currentCurrencyCode)_\(destinationCurrencyCode)"
        self.apiSearchQuery = newSearch
        
    }
    
    
    // Read
    
    // Update
    func updateAPISearchQuery(currentCurrencyCode: String, destinationCurrencyCode: String) {
        let updatedSearch = "\(currentCurrencyCode)_\(destinationCurrencyCode)"
        self.apiSearchQuery = updatedSearch
    }
    
    // Delete
    func deleteAPISearchQuery() {
        self.apiSearchQuery = ""
    }
    
}
