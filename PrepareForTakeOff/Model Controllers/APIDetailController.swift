//
//  APIDetailController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 1/8/20.
//  Copyright © 2020 Julia Rodriguez. All rights reserved.
//

import Foundation

class APIDetailController {
    
    static let shared = APIDetailController()
    
    var apiDetails: [APIDetail] = []
    
    let weather = APIDetail(title: "Open Weather", description: "Provides 5-day weather forecast, with data every 3 hours", logoImageName: "openWeatherGray", urlAsString: "https://openweathermap.org/")
    let currencyExchange = APIDetail(title: "Currency Exchange", description: "Provides currency rates refresh every 15 minutes", logoImageName: "nounMoneyExchange", urlAsString: "https://www.currencyconverterapi.com/")
    let destinationAndPOI = APIDetail(title: "Triposo", description: "Provides destination and point of interest content for 50 US states and abroad countries.", logoImageName: "triposo", urlAsString: "https://www.triposo.com/")
    let events = APIDetail(title: "Eventful", description: "Provides events at geolocation based on trip dates", logoImageName: "Eventful_logo", urlAsString: "https://eventful.com")
    
    func loadAPIDetails() {
        apiDetails = [destinationAndPOI, events, weather, currencyExchange]
    }
}
