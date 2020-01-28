//
//  UXDesginerController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 1/8/20.
//  Copyright © 2020 Julia Rodriguez. All rights reserved.
//

import Foundation

class UXDesginerController {
    
    static let shared = UXDesginerController()
    
    var completeAttribution: [UXDesigner] = []
    
    let sageDetails = UXDesigner(nameAndTitle: "Sage Stamper | UX Designer", description: "App design, user experience research, user interface, and color schemes accreditted to Sage Stamper. View her other work and connect down below.", mediumURL: "https://medium.com/@sagestamper", linkedinURL: "https://www.linkedin.com/in/sagestamper/")
    
    func loadUXDesignerDetails() {
        completeAttribution = [sageDetails]
    }
    
}
