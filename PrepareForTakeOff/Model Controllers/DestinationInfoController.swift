//
//  PointsOfInterestController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/6/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

private let account = "PCFXLMEF"
private let token = "lhc56p3ugf22ov8mny3mumskbnsnzuym"
private let accountHeader = "X-Triposo-Account"
private let tokenHeader = "X-Triposo-Token"

class DestinationInfoController {
    
    static let shared = DestinationInfoController()
    let results: [DestinationInfo] = []
    
    let baseURL = URL(string: "https://www.triposo.com/api/20190906/location.json")
    // only country
    func fetchCountryDestinationInfo(selected userCountryCode: String, completion: @escaping ([DestinationInfo]?) -> Void) {
        
        guard let url = baseURL else { completion(nil); return }
        
        // components to url
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        // query items
        let countryCodeQuery = URLQueryItem(name: "countrycode", value: userCountryCode)
        
        components?.queryItems = [countryCodeQuery]
        
        guard let finalURL = components?.url else { completion(nil); return}
        
        var request = URLRequest(url: finalURL)
        
        request.addValue(account, forHTTPHeaderField: accountHeader)
        request.addValue(token, forHTTPHeaderField: tokenHeader)
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
                let topLevelJSON = try jsonDecoder.decode(TopLevelJSON.self, from: data)
                completion(topLevelJSON.results)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) /n --- /n \(error)")
                completion(nil)
                return
            }
        }.resume()
    }
    
    func fetchCountryDestinationImage(imageUrl: Thumbnail, completion: @escaping (UIImage?) -> Void) {
        
        guard let imageUrl = URL(string: imageUrl.urlAsString) else { return }
        
        URLSession.shared.dataTask(with: imageUrl) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("Couldn't fetch imageUrl data")
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
    
    // city, state == USA
    func fetchStateDestinationInfo(selected userStateCode: String, userCountryCode: String, completion: @escaping ([DestinationInfo]?) -> Void) {
        
        guard let url = baseURL else { completion(nil); return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let stateCodeQuery = URLQueryItem(name: "us_statecode", value: userStateCode)
        
        let countryCodeQuery = URLQueryItem(name: "countrycode", value: userCountryCode)
        
        components?.queryItems = [stateCodeQuery, countryCodeQuery]
        
        guard let finalURL = components?.url else { completion(nil); return }
        
        var request = URLRequest(url: finalURL)
        
        request.addValue(account, forHTTPHeaderField: accountHeader)
        request.addValue(token, forHTTPHeaderField: tokenHeader)
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
                let topLevelJSON = try jsonDecoder.decode(TopLevelJSON.self, from: data)
                completion(topLevelJSON.results)
            } catch {
                print("Failed to decode the data")
            }
        }.resume()
    }
    
    func fetchStateDestinationImage(imageURL: Thumbnail, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: imageURL.urlAsString) else { return }
        
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("Couldn't fetch imageURL data")
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
