//
//  EventController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/20/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

private let app_key = "6sxWwRHwpL9ThMKC"

class EventController {
    
    let results: Event? = nil
    
    // base URL
    let baseURL = URL(string: "http://api.eventful.com/json/events/search")
    
    static let shared = EventController()
    
    func fetchEventsForTrip(location: String, dateRange: String, completion: @escaping (Event?) -> Void) {
        guard let url = baseURL else { completion(nil); return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let locationQuery = URLQueryItem(name: "location", value: location)
        
        let dateRangeQuery = URLQueryItem(name: "date", value: dateRange)
        
        let appKeyQuery = URLQueryItem(name: "app_key", value: app_key)
        
        components?.queryItems = [locationQuery, dateRangeQuery, appKeyQuery]
        
        guard let finalURL = components?.url else { completion(nil); return }
        
        var request = URLRequest(url: finalURL)
        print(request)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let data = data else { completion(nil); return }
            do {
                let jsonDecoder = JSONDecoder()
                let topLevelEventsJson = try jsonDecoder.decode(TopLevelEventsJSON.self, from: data)
                completion(topLevelEventsJson.events)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
        }.resume()
    }
    
    // apple maps api call with latitude and longitude as parameters
}
