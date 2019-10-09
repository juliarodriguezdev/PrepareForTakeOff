//
//  CurrencyExchangeRateController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/8/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation


// https://free.currconv.com/api/v7/convert?q=USD_MXN&compact=ultra&apiKey=04cca92804dc3b53b6c4

private let api_Key = "04cca92804dc3b53b6c4"

class CurrencyExchangeRateController {
    // how to initialize a double
    let result: [CurrencyExchangeRate] = []
    
    
    // base URL
    let baseURL = URL(string: "https://free.currconv.com/api/v7/convert")
    
    static let shared = CurrencyExchangeRateController()
    
    
    func fetchCurrencyExchangeRate(with search: String, completion: @escaping ([CurrencyExchangeRate]?) -> Void) {
        
        let searchString = CurrencyExchangeCodesController.shared.apiSearchQuery
        
        guard let url = baseURL else { completion(nil); return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let searchQuery = URLQueryItem(name: "q", value: searchString)
        
        let defaultQuery = URLQueryItem(name: "compact", value: "ultra")
        
        let apiKeyQuery = URLQueryItem(name: "apiKey", value: api_Key)
        
        components?.queryItems = [searchQuery, defaultQuery, apiKeyQuery]
        
        guard let finalURL = components?.url else { completion(nil); return }
        
        var request = URLRequest(url: finalURL)
        
        request.httpMethod = "GET"
        print(request)
        
        //URLSession
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let data = data else { completion(nil); return }
            do {
                let jsonDecoder = JSONDecoder()
                let decodedData = try? jsonDecoder.decode([String: CurrencyExchangeRate].self, from: data)
                //let exchangeRate = CurrencyExchangeRate(currentRate: decodedData?[searchString])
                //let test = CurrencyExchangeRate(from: decodedData[searchString] ?? "")
            } catch {
                print("failed to decode the data")
                completion(nil)
                return
            }
        }.resume()
        
        
    }
    
    
    
}
