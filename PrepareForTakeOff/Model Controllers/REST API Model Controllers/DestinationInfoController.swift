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
    func fetchCountryDestinationInfo(countryCode: String, completion: @escaping ([DestinationInfo]?) -> Void) {
        
        guard let url = baseURL else { completion(nil); return }
        
        // components to url
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        // query items
        let countryCodeQuery = URLQueryItem(name: "countrycode", value: countryCode)
        
        components?.queryItems = [countryCodeQuery]
        
        guard let finalURL = components?.url else { completion(nil); return}
        
        var request = URLRequest(url: finalURL)
        
        request.addValue(account, forHTTPHeaderField: accountHeader)
        request.addValue(token, forHTTPHeaderField: tokenHeader)
        request.httpMethod = "GET"
        print(request)
                
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
    
//    func fetchCountryDestinationImage(imageUrl: Medium, completion: @escaping (UIImage?) -> Void) {
//
//        guard let imageUrl = URL(string: imageUrl.urlAsString) else { return }
//
//        URLSession.shared.dataTask(with: imageUrl) { (data, _, error) in
//            if let error = error {
//                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
//                completion(nil)
//                return
//            }
//            guard let data = data else {
//                print("Couldn't fetch imageUrl data")
//                completion(nil)
//                return
//            }
//            let image = UIImage(data: data)
//            completion(image)
//        }.resume()
//    }
    
    // city, state == USA
    func fetchStateDestinationInfo(stateCode: String, countryCode: String = "US", completion: @escaping ([DestinationInfo]?) -> Void) {
        
        guard let url = baseURL else { completion(nil); return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let stateCodeQuery = URLQueryItem(name: "us_statecode", value: stateCode)
        
        let countryCodeQuery = URLQueryItem(name: "countrycode", value: countryCode)
        
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
    
    func fetchDestinationImage(imageURL: Medium, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: imageURL.urlAsString) else { return }
        print(imageURL)
        
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
    
    func fetchMapsURL(destinationInfo: DestinationInfo, completion: @escaping (URL?) -> Void) {
        let mapsBaseURL = URL(string: "http://maps.apple.com/")
        
        guard let url = mapsBaseURL else { return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        var latitudeAndLongitude: String {
            var latString = ""
            var longString = ""
            guard let latitude = destinationInfo.coordinates.latitude,
                let longitude = destinationInfo.coordinates.longitude else { return ""}
            latString = String(latitude)
            longString = String(longitude)
            
            let fullStringCoordinates = latString + "," + longString
            return fullStringCoordinates
        }
        let nameOfPlace = URLQueryItem(name: "q", value: destinationInfo.name)
        let coordinates = URLQueryItem(name: "near", value: latitudeAndLongitude)
        
        components?.queryItems = [nameOfPlace, coordinates]
        guard let finalCoordinatesURL = components?.url else { return }
        print(finalCoordinatesURL)
        
        UIApplication.shared.open(finalCoordinatesURL) { (success) in
            if success {
                print("Sent to apple maps from DestinationInfoController")
                completion(finalCoordinatesURL)
            } else {
                print("Coordinates not able to send to apple maps from DestinationInfoController")
                completion(nil)
            }
        }
    }
}
