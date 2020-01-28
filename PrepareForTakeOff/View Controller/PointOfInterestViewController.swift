//
//  PointOfInterestViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/15/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit
import Network

class PointOfInterestViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // source of truth
    var pointOfInterestResults: [PointOfInterest] = []
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "PointOfInterestMonitor")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        nameLabel.text = "Points of Interest"
        self.view.backgroundColor = UIColor.travelBackground
        tableView.backgroundColor = UIColor.travelBackground
        activityIndicator.hidesWhenStopped = true 
        self.tabBarController?.tabBar.isHidden = true 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        activityIndicator.startAnimating()
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
        fetchPointOfInterestResults()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        monitor.cancel()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchPointOfInterestResults() {
        // get a trip
        guard let trip = TripController.shared.tripForAllTabs else { return }
        
        if self.monitor.currentPath.status == .satisfied {
            if trip.inUSA == true {
                     let stateName = TripController.shared.fetchStateFullName(code: trip.destinationStateCode ?? "")
                     
                     if !stateName.isEmpty {
                         self.nameLabel.text = "Points of Interest in \(stateName)"
                         PointOfInterestController.shared.fetchPointOfInterestForState(stateCode: trip.destinationStateCode ?? "") { (pointOfInterestResults) in
                             if let pointsOfInterestFetched = pointOfInterestResults {
                                 self.pointOfInterestResults = pointsOfInterestFetched
                                 DispatchQueue.main.async {
                                     self.activityIndicator.stopAnimating()
                                     self.tableView.reloadData()
                                 }
                             } else {
                                 DispatchQueue.main.async {
                                     self.activityIndicator.stopAnimating()
                                     self.presentUIHelperAlert(title: "No Info", message: "Sorry, couldn't retrieve points of interest info")
                                 }
                             }
                         }
                     } else {
                         nameLabel.text = "Points of Interest"
                         activityIndicator.stopAnimating()
                         presentUIHelperAlert(title: "No Info", message: "Sorry, couldn't retrieve points of interest info")
                     }
                     
                    } else {
                     if let countryName = trip.destinationCountryName {
                         nameLabel.text = "Points of Interest in \(countryName)"
                     } else {
                         nameLabel.text = "Points of Interest"
                     }
                     
                     PointOfInterestController.shared.fetchPointOfInterestForCountry(countryCode: trip.destinationCountryCode ?? "") { (pointOfInterestResults) in
                         if let pointsOfInterestFetched = pointOfInterestResults {
                             self.pointOfInterestResults = pointsOfInterestFetched
                             DispatchQueue.main.async {
                                 self.activityIndicator.stopAnimating()
                                 self.tableView.reloadData()
                             }
                         } else {
                             DispatchQueue.main.async {
                                 self.activityIndicator.stopAnimating()
                                 self.presentUIHelperAlert(title: "No Info", message: "Sorry, couldn't retrieve points of interest info")
                             }
                         }
                     }
                 }
            
        } else if self.monitor.currentPath.status == .unsatisfied {
            self.activityIndicator.stopAnimating()
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

extension PointOfInterestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointOfInterestResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pointOfInterestCell", for: indexPath) as? PointOfInterestTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = UIColor.travelBackground
        cell.selectionStyle = .none
        let pointOfInterest = pointOfInterestResults[indexPath.row]
        cell.pointOfInterest = pointOfInterest
        cell.updateViews()
        return cell
    }
    
    
}
