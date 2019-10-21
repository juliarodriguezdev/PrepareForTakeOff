//
//  Event.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/20/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

struct TopLevelEventsJSON: Codable {
    let events: Event
}

struct Event: Codable {
    let event: [SingleEvent]
    
}
struct SingleEvent: Codable {
    let urlAsString: String?
    let city: String?
    let latitude: String?
    let longitude: String?
    let regionName: String?
    let startTime: String?
    let description: String?
    let title: String?
    let venueAddress: String?
    let venueName: String?
    
    
    enum CodingKeys: String, CodingKey {
        case urlAsString = "url"
        case city = "city_name"
        case latitude
        case longitude
        case regionName = "region_name"
        case startTime = "start_time"
        case description
        case title
        case venueAddress = "venue_address"
        case venueName = "venue_name"
    }
}
