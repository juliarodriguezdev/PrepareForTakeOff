//
//  PointOfInterestViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/15/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class PointOfInterestViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // source of truth
    var pointOfInterestResults: [PointOfInterest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchPointOfInterestResults()
        // add networking to check for internet
        // call func to make api call
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true 
    }
    
    func fetchPointOfInterestResults() {
        // get a trip
        guard let trip = TripController.shared.tripForAllTabs else { return }
        // call api from model object
        // in USA
        if trip.inUSA == true {
            PointOfInterestController.shared.fetchPointOfInterestForState(stateCode: trip.destinationStateCode ?? "") { (pointOfInterestResults) in
            if let pointsOfInterestFetched = pointOfInterestResults {
                    self.pointOfInterestResults = pointsOfInterestFetched
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
        // false == Abroad
        } else {
            PointOfInterestController.shared.fetchPointOfInterestForCountry(countryCode: trip.destinationCountryCode ?? "") { (pointOfInterestResults) in
                if let pointsOfInterestFetched = pointOfInterestResults {
                    self.pointOfInterestResults = pointsOfInterestFetched
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
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
        
        let pointOfInterest = pointOfInterestResults[indexPath.row]
        cell.pointOfInterest = pointOfInterest
        cell.updateViews()
        return cell
    }
    
    
}
