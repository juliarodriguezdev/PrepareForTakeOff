//
//  EventsViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/20/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit
import Network

class EventsViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var activityIndicatior: UIActivityIndicatorView!
    
    var events: Event?
    
    var cityName: String = ""
    var stateName: String = ""
    var countryName: String = ""
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "EventsMonitor")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        self.view.backgroundColor = UIColor.travelBackground
        eventTableView.backgroundColor = UIColor.travelBackground
        fetchEventResults()
        self.tabBarController?.tabBar.isHidden = true
        nameLabel.text = "Events"
        activityIndicatior.hidesWhenStopped = true 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        activityIndicatior.startAnimating()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Network connection is available")
            } else {
                print("No network connection")
            }
        }
        monitor.start(queue: queue)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchEventResults()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        monitor.cancel()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        
        if self.monitor.currentPath.status == .satisfied {
            if trip.inUSA == true {
                // location == city, state
                if let stateCode = trip.destinationStateCode {
                    let stateFullName = TripController.shared.fetchStateFullName(code: stateCode)
                    stateName = stateFullName
                }
                let searchLocation = cityName + ", " + stateName
                nameLabel.text = "Events at \(cityName), \(stateName)"
                
                print("Search Location for State is: \(searchLocation)")
                EventController.shared.fetchEventsForTrip(location: searchLocation, dateRange: dateRange) { (eventResults) in
                    if let fetchedEvents = eventResults {
                        self.events = fetchedEvents
                        DispatchQueue.main.async {
                            self.activityIndicatior.stopAnimating()
                            self.eventTableView.reloadData()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.activityIndicatior.stopAnimating()
                            self.presentUIHelperAlert(title: "No Info", message: "Sorry, couldn't retrieve events")
                        }
                    }
                }
            } else {
                
                if let countryFullName = trip.destinationCountryName {
                    countryName = countryFullName
                }
                let searchLocation = cityName + ", " + countryName
                nameLabel.text = "Events at \(cityName), \(countryName)"
                EventController.shared.fetchEventsForTrip(location: searchLocation, dateRange: dateRange) { (eventResults) in
                    if let fetchedEvents = eventResults {
                        self.events = fetchedEvents
                        DispatchQueue.main.async {
                            self.activityIndicatior.stopAnimating()
                            self.eventTableView.reloadData()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.activityIndicatior.stopAnimating()
                            self.presentUIHelperAlert(title: "No Info", message: "Sorry, couldn't retrieve events")
                        }
                    }
                }
            }
            
        } else if self.monitor.currentPath.status == .unsatisfied {
            self.activityIndicatior.stopAnimating()
            self.presentUIHelperAlert(title: "No Connectivity", message: "Please enable internet connectivity on your device")
        }
        
    }
    
    func presentUIHelperAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
    
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.event.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventsTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = UIColor.travelBackground
        cell.selectionStyle = .none
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
        guard let indexPath = eventTableView.indexPath(for: cell) else { return }
        
        let singleEvent = events?.event[indexPath.row]
        
        if let event = singleEvent {
            EventController.shared.fetchMapsURL(event: event) { (url) in
                if url != nil {
                    print("event sent to apple maps")
                } else {
                    print("event unable to navigate to apple maps")
                }
            }
        }
        
    }
    
    
}
