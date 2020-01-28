//
//  EventsTableViewCell.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/20/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

protocol EventURLDelegate: class {
    func navigatetoEventURL(for cell: EventsTableViewCell)
    
    func navigateToMaps(for cell: EventsTableViewCell)
}

class EventsTableViewCell: UITableViewCell {
    
    var event: SingleEvent?
    
    weak var delegate: EventURLDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cityRegionLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var venueNameLabel: UILabel!
    
    @IBOutlet weak var venueAddressLabel: UILabel!
    
    @IBOutlet weak var eventURLButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }
    
    func updateViews() {
        guard let event = event else { return }
        
        var filteredDescription: String {
            let description = event.description
            var placeHolderDescription = ""
            
            if let str = description?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) {
                placeHolderDescription = str
                
                if str.contains("&#39;") == true {
                    let removeExcess = str.replacingOccurrences(of: "&#39;", with: "'", options: .literal, range: nil)
                    placeHolderDescription = removeExcess
                }
                
            }
                      
            let trimmedString = placeHolderDescription.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmedString
        }
        
        descriptionLabel.text = filteredDescription
        titleLabel.text = event.title
        cityRegionLabel.text = (event.city ?? "") + ", " + (event.regionName ?? "")
        
        var timeDateOfEvent: String {
            var dateStringPlaceHolder = ""
            let convertedDate = event.startTime?.convertToDate()
            if let formattedDate = convertedDate?.convertToViewableDate() {
                dateStringPlaceHolder = formattedDate
                
            }
            return dateStringPlaceHolder
        }
        startTimeLabel.text = "When: " + timeDateOfEvent
        
        
        venueNameLabel.text = "Where: " + (event.venueName ?? "")
        venueAddressLabel.text = event.venueAddress
    }

    @IBAction func eventURLButtonTapped(_ sender: Any) {
        delegate?.navigatetoEventURL(for: self)
    }
    
    @IBAction func compassButtonTapped(_ sender: UIButton) {
        delegate?.navigateToMaps(for: self)
    }
    
}
