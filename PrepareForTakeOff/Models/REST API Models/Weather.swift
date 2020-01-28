//
//  Weather.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/7/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

struct WeatherTopLevelJSON: Codable {
    let list: [WeatherDetails]
}

struct WeatherDetails: Codable {
    let timeOfForecast: Int
    let timestampOfForecast: String
    let main: Main
    let weather: [WeatherSubDetails]
    let wind: Wind
    
    enum CodingKeys: String, CodingKey {
        case timeOfForecast = "dt"
        case timestampOfForecast = "dt_txt"
        case main
        case weather
        case wind
    }
}

struct Main: Codable {
    let temp: Double
    let pressure: Double
    let seaLevel: Double
    let groundLevel: Double
    let humidity: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case pressure
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
        case humidity
    }
}

struct WeatherSubDetails: Codable {
    let main: String
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case description
        case icon
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Double
    
    enum CodingKeys: String, CodingKey {
        case speed
        case deg
    }
}
extension WeatherDetails: Equatable {
    static func == (lhs: WeatherDetails, rhs: WeatherDetails) -> Bool {
        return lhs.timestampOfForecast == rhs.timestampOfForecast
    }
    
    
}
