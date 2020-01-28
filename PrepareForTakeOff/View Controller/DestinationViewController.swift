//
//  DestinationViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/16/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit
import Network

class DestinationViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var destinationTableView: UITableView!
    @IBOutlet weak var indicatorWheel: UIActivityIndicatorView!
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "DestinationMonitor")
   
    var destinationResults: [DestinationInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        destinationTableView.delegate = self
        destinationTableView.dataSource = self
        self.view.backgroundColor = UIColor.travelBackground
        destinationTableView.backgroundColor = UIColor.travelBackground
        indicatorWheel.hidesWhenStopped = true 
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        indicatorWheel.startAnimating()
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
        fetchDestinationInfoResults()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        monitor.cancel()
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
        
    func fetchDestinationInfoResults() {

        guard let trip = TripController.shared.tripForAllTabs else { return }
    
        if self.monitor.currentPath.status == .satisfied {
            if trip.inUSA == true {
                    let stateName = TripController.shared.fetchStateFullName(code: trip.destinationStateCode ?? "")
                    nameLabel.text = "Top Destinations in \(stateName)"
                    if !stateName.isEmpty {
                        DestinationInfoController.shared.fetchStateDestinationInfo(stateCode: trip.destinationStateCode ?? "") { (destinationInfoResults) in
                            if let destinationInfoFetched = destinationInfoResults {
                                self.destinationResults = destinationInfoFetched
                                DispatchQueue.main.async {
                                    self.indicatorWheel.stopAnimating()
                                    //self.indicatorWheel.isHidden = true
                                    self.destinationTableView.reloadData()
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.indicatorWheel.stopAnimating()
                                    self.presentUIHelperAlert(title: "No Info", message: "Sorry, couldn't retrieve destination info")
                                }
                            }
                        }
                    } else {
                        indicatorWheel.stopAnimating()
                        presentUIHelperAlert(title: "No Info", message: "Sorry, couldn't retrieve destination info")
                    }
                    
            
                } else {
                    // TODO: Make a ternary operator for this func
                     if let countryName = trip.destinationCountryName {
                        nameLabel.text = "Top Destinations in \(countryName)"
                    } else {
                        nameLabel.text = "Top Destinations"
                    }
                    
                    DestinationInfoController.shared.fetchCountryDestinationInfo(countryCode: trip.destinationCountryCode ?? "") { (destinationInfoResults) in
                        if let destinationInfoFetched = destinationInfoResults {
                            self.destinationResults = destinationInfoFetched
                            DispatchQueue.main.async {
                                self.indicatorWheel.stopAnimating()
                                self.destinationTableView.reloadData()
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.indicatorWheel.stopAnimating()
                                self.presentUIHelperAlert(title: "No Info", message: "Sorry, couldn't retrieve destination info")
                            }
                        }
                    }
                }
        } else if self.monitor.currentPath.status == .unsatisfied {
            self.indicatorWheel.stopAnimating()
            self.presentUIHelperAlert(title: "No Connectivity", message: "Please enable internet connectivity on your device.")
        }
        
    }
    
    
    func presentUIHelperAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
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
        cell.backgroundColor = UIColor.travelBackground
        cell.selectionStyle = .none
        let destinationInfo = destinationResults[indexPath.row]
        cell.destinationInfo = destinationInfo
        cell.updateViews()
        return cell
    }
    
    
}
