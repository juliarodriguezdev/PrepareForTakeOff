//
//  EventsViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/20/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {
    
    @IBOutlet weak var eventTableView: UITableView!
    
    var events: Event?
    
    var cityName: String = ""
    var stateName: String = ""
    var countryName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        fetchEventResults()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchEventResults()
    }
    
    
    func fetchEventResults() {
        guard let trip = TripController.shared.tripForAllTabs else { return }
        // date range, add 00 to end of date
        if let city = trip.destinationCity {
            cityName = city
        }
        //let dateRange = "2019110100-2019111500"
        let dateRange = TripController.shared.fetchDateRangeOfTrip(trip: trip)
        print("Date Range for API Input @ EventViewController is: \(dateRange)")
        
        if trip.inUSA == true {
            // location == city, state
            if let stateCode = trip.destinationStateCode {
                let stateFullName = TripController.shared.fetchStateFullName(code: stateCode)
                stateName = stateFullName
            }
            let searchLocation = cityName + ", " + stateName
            
            print("Search Location for State is: \(searchLocation)")
            EventController.shared.fetchEventsForTrip(location: searchLocation, dateRange: dateRange) { (eventResults) in
                if let fetchedEvents = eventResults {
                    self.events = fetchedEvents
                    DispatchQueue.main.async {
                        self.eventTableView.reloadData()
                    }
                }
            }
        } else {
            // location == city, country
            // country name
            if let countryFullName = trip.destinationCountryName {
                countryName = countryFullName
            }
            let searchLocation = cityName + ", " + countryName
            EventController.shared.fetchEventsForTrip(location: searchLocation, dateRange: dateRange) { (eventResults) in
                if let fetchedEvents = eventResults {
                    self.events = fetchedEvents
                    DispatchQueue.main.async {
                        self.eventTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.event.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventsTableViewCell else { return UITableViewCell() }
        
        let singleEvent = events?.event[indexPath.row]
        cell.event = singleEvent
        cell.delegate = self
        cell.updateViews()
        
        return cell
    }
}

extension EventsViewController: EventURLDelegate {
    func navigatetoEventURL(for cell: EventsTableViewCell) {
        guard let indexPath = eventTableView.indexPath(for: cell) else { return }
        
        let singleEvent = events?.event[indexPath.row]
        
        guard let eventURLString = singleEvent?.urlAsString else { return }
        
        if let eventURL = URL(string: eventURLString) {
            UIApplication.shared.open(eventURL) { (success) in
                if success {
                    print("sent to Eventful URL Page")
                } else {
                    print("did not send to eventful URL page")
                }
            }
        }
    }
    
    func navigateToMaps(for cell: EventsTableViewCell) {
        // do later
        
    }
    
    
}
