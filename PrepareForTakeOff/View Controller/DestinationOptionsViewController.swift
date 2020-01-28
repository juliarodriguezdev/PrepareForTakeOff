//
//  DestinationOptionsViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/21/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class DestinationOptionsViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var destinationButton: UIButton!
    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var pointsOfInterestButton: UIButton!
    @IBOutlet weak var pointsOfInterestLabel: UILabel!
    
    @IBOutlet weak var eventsButton: UIButton!
    @IBOutlet weak var eventsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.tabBar.isHidden = false
        self.view.backgroundColor = UIColor.travelBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        if let trip = TripController.shared.tripForAllTabs?.name {
            nameLabel.text = "\(trip)"
        }
    }
    
    @IBAction func destinationButtonTapped(_ sender: UIButton) {
        showDestinationViewController()
    }
    
    @IBAction func pointsOfInterestButtonTapped(_ sender: UIButton) {
        showPointsOfInterestViewController()
    }
    
    @IBAction func eventsButtonTapped(_ sender: UIButton) {
        showEventsViewController()
    }
  
    func showDestinationViewController() {
        let storyboard = UIStoryboard(name: "DestinationInfo", bundle: nil)
        guard let destinationViewController = storyboard.instantiateViewController(identifier: "DestinationViewController") as? DestinationViewController else { return }
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }

    func showPointsOfInterestViewController() {
        let storyboard = UIStoryboard(name: "DestinationInfo", bundle: nil)
        guard let pointsOfInterestViewController = storyboard.instantiateViewController(identifier: "PointOfInterestViewController") as? PointOfInterestViewController else { return }
        self.navigationController?.pushViewController(pointsOfInterestViewController, animated: true)
    }
    
    func showEventsViewController() {
        let storyboard = UIStoryboard(name: "DestinationInfo", bundle: nil)
        guard let eventsViewController = storyboard.instantiateViewController(identifier: "EventsViewController") as? EventsViewController else { return }
        self.navigationController?.pushViewController(eventsViewController, animated: true)
        
    }

}
