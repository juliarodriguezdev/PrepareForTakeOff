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
       // fetchCityAndCountries()
    }
    
    // source of truth
    var trips: [Trip] {
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        return (try? CoreDataStack.managedObjectContext.fetch(request)) ?? []
    }
    
  //  var cities: [City] = []
    
    var tripForAllTabs: Trip?
    
    // CRUD Funcs
    
    // Create
    func createTripWith(date: Date, destinationCity: String, destinationCountryCode: String, destinationCountryName: String, destinationCurrencyCode: String, destinationStateCode: String?, inUSA: Bool, name: String, userCurrencyCode: String = Locale.current.currencyCode ?? "USD", durationInDays: Int16) {
        
        Trip(date: date, destinationCity: destinationCity, destinationCountryCode: destinationCountryCode, destinationCountryName: destinationCountryName, destinationCurrencyCode: destinationCurrencyCode, destinationStateCode: destinationStateCode, inUSA: inUSA, name: name, userCurrencyCode: userCurrencyCode, durationInDays: durationInDays)
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
            return ""
        }
    }
    
    func fetchCountryCurrencyCode(isoCountryCode: String) -> String {
        // verify this is upper cased (the input)
        if let currencyCode = CurrencyCodesHelper.countryCodes[isoCountryCode] {
            return currencyCode
        } else {
            // Antartica doesn't have a currency
            return ""
        }
    
        
    }
    
    func fetchCityIDNumber(trip: Trip) -> String {
        // inside USA
        // array of all cities to loop through
        var cityIDForFetch: String = ""
        guard let cityName = trip.destinationCity,
        let countryCode = trip.destinationCountryCode else { return ""}
        let allCities = CityResultsController.shared.cities
        
        if trip.inUSA == true {
            let city = allCities.filter({$0.name == cityName && $0.country == "US"}).compactMap({$0})
            // we have an array
            let foundCity = city.first
            if let cityId = foundCity?.cityID {
                cityIDForFetch = cityId
            }
            
        } else {
            let city = allCities.filter({$0.name == cityName && $0.country == countryCode}).compactMap({$0})
            let foundCity = city.first
            if let cityId = foundCity?.cityID {
                cityIDForFetch = cityId
            }
            
        }
        print("City Id from fetch: \(cityIDForFetch)")
        return cityIDForFetch
    }
    
    
    // API Search Query String Func
    func fetchAPIQueryString(trip: Trip) -> String {
       // current usd
        guard let userCurrencyCode = trip.userCurrencyCode,
            let destinationCurrencyCode = trip.destinationCurrencyCode else { return "" }
        let currencyString = ("\(userCurrencyCode)_\(destinationCurrencyCode)").uppercased()
        
        return currencyString
      // destination $ code

    }
    
    func fetchTripReturnDate(trip: Trip) {
        
    }
    
    // create date range string for eventful api
    func fetchDateRangeOfTrip(trip: Trip) -> String  {
        var finalReturnDate: Date?
        // get the departure date of trip
        guard let depatureDate = trip.date else { return ""}
        // get the duration (in days)
        let durationInDays = Int(trip.durationInDays)
        // add the two -> get teh return date of trip
        if let returnDate = Calendar.current.date(byAdding: .day, value: durationInDays, to: depatureDate) {
            finalReturnDate = returnDate
        }
        
        var formattedDepatureDate = depatureDate.stringForAPI()
        formattedDepatureDate.append("00")
        print("Depature Formatted Date: \(formattedDepatureDate)")
        
        guard let userReturnDate = finalReturnDate else { return ""}
        
        var formattedReturnDate = userReturnDate.stringForAPI()
        formattedReturnDate.append("00")
        print("Return formatted Date: \(formattedReturnDate)")
        
        let finalDateRange = formattedDepatureDate + "-" + formattedReturnDate
        return finalDateRange
    }
    
}
