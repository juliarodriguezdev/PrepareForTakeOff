//
//  TripController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/9/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class TripController {
    
    static let shared = TripController()
    
    init(){
        fetchCityAndCountries()
    }
    
    // source of truth
    var trips: [Trip] {
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        return (try? CoreDataStack.managedObjectContext.fetch(request)) ?? []
    }
    
    var cities: [City] = []
    
    // CRUD Funcs
    
    // Create
    func createTripWith(date: Date, destinationCity: String, destinationCountryCode: String, destinationCountryName: String, destinationCurrencyCode: String, destinationStateCode: String?, inUSA: Bool, name: String, userCurrencyCode: String = Locale.current.currencyCode ?? "USD") {
        
        Trip(date: date, destinationCity: destinationCity, destinationCountryCode: destinationCurrencyCode, destinationCountryName: destinationCountryName, destinationCurrencyCode: destinationCountryCode, destinationStateCode: destinationStateCode, inUSA: inUSA, name: name, userCurrencyCode: userCurrencyCode)
        saveToPersistentStore()
    }
    
    // Update
    func updateTrip(trip:Trip) {
        if let moc = trip.managedObjectContext {
            if moc.hasChanges == true {
                saveToPersistentStore()
            }
        }
    }
    
    // Delete
    
    func deleteTrip(trip: Trip) {
        if let moc = trip.managedObjectContext {
            moc.delete(trip)
            saveToPersistentStore()
        }
    }
    
    // Save
    func saveToPersistentStore() {
        let moc = CoreDataStack.managedObjectContext
        do {
            try moc.save()
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
        }
    }
    
    
    // City and Country CRUD Func
    var filePath = Bundle.main.url(forResource: "city.list", withExtension: "json")
    
    // Fetch CIty and Country
    func fetchCityAndCountries() {
        guard let filePath = filePath else { return }
        let jsonDecoder = JSONDecoder()
        do {
            let jsonData = try Data(contentsOf: filePath)
            //let decodedCityList = try jsonDecoder.decode([CityResults].self, from: jsonData)
            let decodedCitiesList = try jsonDecoder.decode([City].self, from: jsonData)
            //let cityList = try jsonDecoder.decode([City].self, from: jsonData)
            //cities = decodedCityList.compactMap({$0.city})
            cities = decodedCitiesList
            //print(jsonData)
            
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")

            //print("There was an error decoding! \(error.localizedDescription)")
        }
    }
    
    // State Funcs
    func fetchStates() -> [String] {
        let statesDictionary = StateHelper.states
        var placeholder = [String]()
        // key, value
        for (_, value) in statesDictionary {
            placeholder.append(value)
        }
        // State, ex: CA
        let alphabetized = placeholder.sorted(by: <)
        
        return alphabetized
    }
    func fetchStateCode(stateFullName: String) -> String {
        let statesDictionary = StateHelper.states
        var placeHolder : String = ""
        
        for (key, value) in statesDictionary {
            if value == stateFullName {
                placeHolder = key
            }
        }
        let stateCode = placeHolder
        return stateCode
    }
    
    func fetchStateFullName(code: String) -> String {
        if let stateName = StateHelper.states[code] {
            return stateName
        } else {
         return code
        }
    }
    
    func fetchCountryCode(countryFullName: String) -> String {
        let countryNameArray = Locale.isoRegionCodes.compactMap(Locale.current.localizedString(forRegionCode:))
        let regionCodesArray = Locale.isoRegionCodes
        var countryCodePlaceHolder = ""
        
        // get the indexpath of the array
        if let index = countryNameArray.firstIndex(of: countryFullName) {
            let countryRegionCode = regionCodesArray[index]
            countryCodePlaceHolder = countryRegionCode
            return countryCodePlaceHolder
        } else {
            return countryFullName
        }
    }
    
    func fetchCountryCurrencyCode(isoCountryCode: String) -> String {
        let currencyCode = CurrencyCodesHelper.countryCodes[isoCountryCode]
        if currencyCode != nil {
            return isoCountryCode
        } else {
            // Antartica doesn't have a currency
            return ""
        }
        
    }
    
    
    // API Search Query String Func
    func fetchAPIQueryString() {
       

    }
    

    
}
