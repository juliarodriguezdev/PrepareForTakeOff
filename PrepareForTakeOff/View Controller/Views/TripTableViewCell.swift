//
//  TripTableViewCell.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/11/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    
    var trip: Trip?
    
    @IBOutlet weak var tripNameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateViews() {
        guard let trip = trip else { return }
        tripNameLabel.text = trip.name
        dateLabel.text = trip.date?.stringValue()
       
        if trip.inUSA == true {
            let stateName = TripController.shared.fetchStateFullName(code: trip.destinationStateCode!)
            locationLabel.text = "\(trip.destinationCity!), \(stateName)"
        } else {
            locationLabel.text = "\(trip.destinationCountryName!)"
        }
    }

}
