//
//  DateFormatter.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/9/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation

extension Date {
    
    func stringValue() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self)
    }
    
    func stringForAPI() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        return formatter.string(from: self)
    }
    
    // for the display on the table view 
    func convertToViewableDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: self)
    }
    func convertToDescription() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self)
    }
    
    var day: Int? {
        let components = Calendar.current.dateComponents([.day], from: self)
        return components.day
    }
}

