//
//  TripViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/9/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class TripViewController: UIViewController {
    // is rootview controller
    
    @IBOutlet weak var tripTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // title = "Trips"
        tripTableView.delegate = self
        tripTableView.dataSource = self
        self.view.backgroundColor = UIColor.travelBackground
        tripTableView.backgroundColor = UIColor.travelBackground
        //self.tabBarController?.tabBar.isHidden = true
       // let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTripBarButtonItemTapped(_:)))
        
        //self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        tripTableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let index = tripTableView.indexPathForSelectedRow,
            let destinationVC = segue.destination as? PackingListViewController else { return }
        let trip = TripController.shared.trips[index.row]
        // set trip to share across all tabs
        TripController.shared.tripForAllTabs = trip
        destinationVC.trip = trip
        
    }
    
    @IBAction func createTripButtonTapped(_ sender: Any) {
        showCreateTripViewController()
    }
    
    func showCreateTripViewController() {
        let storyboard = UIStoryboard(name: "CreateTrip", bundle: nil)
        guard let createTripViewController = storyboard.instantiateViewController(withIdentifier: "CreateTripViewController") as? CreateTripViewController else { return }
        self.navigationController?.pushViewController(createTripViewController, animated: true)
       
    }
    
    @objc func addTripBarButtonItemTapped(_ sender: UIBarButtonItem) {
        let storyBoard = UIStoryboard(name: "CreateTrip", bundle: nil)
        guard let createTripViewController = storyBoard.instantiateViewController(withIdentifier: "CreateTripViewController") as? CreateTripViewController else { return }
        self.navigationController?.pushViewController(createTripViewController, animated: true)
    }
}

extension TripViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TripController.shared.trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as? TripTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = UIColor.travelBackground
        cell.selectionStyle = .none
        let trip = TripController.shared.trips[indexPath.row]
        cell.trip = trip
        cell.updateViews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let trip = TripController.shared.trips[indexPath.row]
            TripController.shared.deleteTrip(trip: trip)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}
