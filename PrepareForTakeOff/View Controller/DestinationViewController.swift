//
//  DestinationViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/16/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class DestinationViewController: UIViewController {

    @IBOutlet weak var destinationTableView: UITableView!
    
    var destinationResults: [DestinationInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        destinationTableView.delegate = self
        destinationTableView.dataSource = self
        fetchDestinationInfoResults()
        // Do any additional setup after loading the view.
    }
    
    func fetchDestinationInfoResults() {
        guard let trip = TripController.shared.tripForAllTabs else { return }
        
        // USA trip
        if trip.inUSA == true {
            let stateName = TripController.shared.fetchStateFullName(code: trip.destinationStateCode ?? "")
            self.title = "About \(stateName)"
            DestinationInfoController.shared.fetchStateDestinationInfo(stateCode: trip.destinationStateCode ?? "") { (destinationInfoResults) in
                if let destinationInfoFetched = destinationInfoResults {
                    self.destinationResults = destinationInfoFetched
                    DispatchQueue.main.async {
                        self.destinationTableView.reloadData()
                    }
                }
            }
           
        // abroad trip
        } else {
            // TODO: Make a ternary operator for this func 
            if let countryName = trip.destinationCountryName {
                self.title = "Points of Interest in \(countryName)"
            } else {
                self.title = "Points of Interest"
            }
            
            DestinationInfoController.shared.fetchCountryDestinationInfo(countryCode: trip.destinationCountryCode ?? "") { (destinationInfoResults) in
                if let destinationInfoFetched = destinationInfoResults {
                    self.destinationResults = destinationInfoFetched
                    DispatchQueue.main.async {
                        self.destinationTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension DestinationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinationResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "destinationCell", for: indexPath) as? DestinationTableViewCell else { return UITableViewCell()}
        
        let destinationInfo = destinationResults[indexPath.row]
        cell.destinationInfo = destinationInfo
        cell.updateViews()
        return cell
    }
    
    
}
