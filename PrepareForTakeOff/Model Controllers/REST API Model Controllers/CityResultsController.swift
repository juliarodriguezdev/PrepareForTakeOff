//
//  CityResultsController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/7/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation

class CityResultsController {
    
    static let shared = CityResultsController()
    
    var cities : [City] = []
    
    var filePath = Bundle.main.url(forResource: "history.city.list", withExtension: "json")
    
    init() {
        loadFromPersistentStorage()
    }
    
    func loadFromPersistentStorage() {
        guard let filePathURL = filePath else { return }
        
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: filePathURL)
            let cityResults = try decoder.decode([City].self, from: data)
            //self.cities = cityResults.cities
            cities = cityResults
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")

        }
    }
}
