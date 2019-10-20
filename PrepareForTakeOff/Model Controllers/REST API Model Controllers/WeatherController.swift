//
//  WeatherController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/7/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

private let apiKey = "0a22a03c9a9015c59e9463a9bd2532aa"

class WeatherController {
    
    let results: [WeatherDetails] = []
    
    let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/forecast")
    
    static let shared = WeatherController()
    
    func fetch5DayCityIDWeatherForecast(cityID: String, completion: @escaping ([WeatherDetails]?) -> Void) {
        guard let url = baseURL else { completion(nil); return }
        
        // add components to url
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        //let unitsQuery = URLQueryItem(name: "units", value: "imperial")
        
        let cityIDQuery = URLQueryItem(name: "id", value: cityID)
                
        let apiKeyQuery = URLQueryItem(name: "appid", value: apiKey)
        
        components?.queryItems = [cityIDQuery, apiKeyQuery]
        
        guard let finalURL = components?.url else { completion(nil); return }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        print("5Day City ID URL: \(request)")
        
        // URLSession
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let data = data else { completion(nil); return }
            do {
                let jsonDecoder = JSONDecoder()
                let weatherTopLevelJSON = try jsonDecoder.decode(WeatherTopLevelJSON.self, from: data)
                completion(weatherTopLevelJSON.list)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) /n --- /n \(error)")
                completion(nil)
                return 
            }
        }.resume()
        
    }
    
    func fetch5DayCityCountryCodeForecast(city: String, countryCode: String, completion: @escaping ([WeatherDetails]?)-> Void) {
        guard let url = baseURL else { completion(nil); return }
        
        let cityCountryCode = "\(city),\(countryCode)"
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let cityCountryCodeQuery = URLQueryItem(name: "q", value: cityCountryCode)
        
        let unitsQuery = URLQueryItem(name: "units", value: "imperial")
        
        let apiKeyQuery = URLQueryItem(name: "appid", value: apiKey)
        
        components?.queryItems = [cityCountryCodeQuery, unitsQuery, apiKeyQuery]
        
        guard let finalURL = components?.url else { completion(nil); return }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        print(request)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion([])
                return
            }
            guard let data = data else { completion(nil); return }
            do {
                let jsonDecoder = JSONDecoder()
                let weatherTopLevelJson = try jsonDecoder.decode(WeatherTopLevelJSON.self, from: data)
                completion(weatherTopLevelJson.list)
            } catch {
                print("Failed to decode the data")
                completion(nil)
                return
            }
        }.resume()
    }
}
