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
    
    let baseURL = URL(string: "api.openweathermap.org/data/2.5/forecast")
    
    static let shared = WeatherController()
    
    func fetch5DayWeatherForecast(for latitude: Double, longitude: Double, completion: @escaping ([WeatherDetails]?) -> Void) {
        guard let url = baseURL else { completion(nil); return }
        
        // add components to url
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let latitudeQuery = URLQueryItem(name: "lat", value: "\(latitude)")
        
        let longitudeQuery = URLQueryItem(name: "lon", value: "\(longitude)")
        
        let apiKeyQuery = URLQueryItem(name: "appid", value: apiKey)
        
        components?.queryItems = [latitudeQuery, longitudeQuery, apiKeyQuery]
        
        guard let finalURL = components?.url else { completion(nil); return }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        print(request)
        
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
                print("Failed to decode the data")
                completion(nil)
                return 
            }
        }.resume()
        
    }
}
