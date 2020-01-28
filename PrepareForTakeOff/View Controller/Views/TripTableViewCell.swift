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
        
    @IBOutlet weak var dateLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateViews() {
        guard let trip = trip else { return }
        tripNameLabel.text = trip.name
        let duration = Int(trip.durationInDays)
        if let depatureDate = trip.date {
            if let returnDate = Calendar.current.date(byAdding: .day, value: duration, to: depatureDate) {
                
                if duration <= 1 {
                    dateLabel.text = depatureDate.returnDateString() + " (1 day trip)"
                } else {
                    dateLabel.text = depatureDate.depatureDateString() + " - " + returnDate.returnDateString()
                }
            }
            /* let today = Date()
            let countdownComponents = Calendar.current.dateComponents([.day], from: today, to: depatureDate)
            if let countdown = countdownComponents.day {
                if countdown > 0 {
                    countdownLabel.text = "\(countdown) days until take off"
                    countdownLabel.textColor = .black
                } else if countdown == 0 {
                    countdownLabel.text = "Trip is today!"
                    countdownLabel.textColor = .systemGreen
                } else if countdown == 1 {
                    countdownLabel.text = "Trip is tomorrow!"
                    countdownLabel.textColor = .systemYellow
                } else if countdown < 0 {
                    countdownLabel.text = "Trip Completed"
                    countdownLabel.textColor = .systemRed
                }
            } */
        }
       
       /* if trip.inUSA == true {
            let stateName = TripController.shared.fetchStateFullName(code: trip.destinationStateCode ?? "")
             if let cityName = trip.destinationCity  {
                
                locationLabel.text = "\(cityName), \(stateName)"
            }
        } else {
            if let countryName = trip.destinationCountryName,
                let cityName = trip.destinationCity {
                
                locationLabel.text = "\(cityName), \(countryName)"
            }
        } */
    }

}
