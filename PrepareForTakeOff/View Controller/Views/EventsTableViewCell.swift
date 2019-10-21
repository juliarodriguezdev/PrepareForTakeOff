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
            if let removeSyntax = description?.replacingOccurrences(of: "<p>", with: "") {
                placeHolderDescription = removeSyntax
                
                if removeSyntax.contains("<strong>") == true {
                    let removeStrong = removeSyntax.replacingOccurrences(of: "<strong>", with: "")
                    placeHolderDescription = removeStrong
                    
                    if removeStrong.contains("</strong>") == true {
                        let removeAgainStrong = removeStrong.replacingOccurrences(of: "</strong", with: "")
                        placeHolderDescription = removeAgainStrong
                        
                        if removeAgainStrong.contains("<br>") == true {
                            let removeBR = removeAgainStrong.replacingOccurrences(of: "<br>", with: "")
                            placeHolderDescription = removeBR
                            
                            if removeBR.contains("<em>") == true {
                                let removeEM = removeBR.replacingOccurrences(of: "<em>", with: "")
                                placeHolderDescription = removeEM
                                
                                if removeEM.contains("</em>") == true {
                                    let removeAgainEM = removeEM.replacingOccurrences(of: "</em>", with: "")
                                    placeHolderDescription = removeAgainEM
                                    
                                    if removeAgainEM.contains(">") == true {
                                        let removeRightCarrot = removeAgainEM.replacingOccurrences(of: ">", with: "")
                                        placeHolderDescription = removeRightCarrot
                                        
                                        if removeRightCarrot.contains("</p>") == true {
                                            let removeAgainP = removeRightCarrot.replacingOccurrences(of: "</p>", with: "")
                                            placeHolderDescription = removeAgainP
                                            
                                            if removeAgainP.contains("&#39;") == true {
                                                let removeSymbols = removeAgainP.replacingOccurrences(of: "&#39;", with: "'")
                                                placeHolderDescription = removeSymbols
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
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
