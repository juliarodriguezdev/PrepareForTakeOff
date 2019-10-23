//
//  StringFormatter.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/20/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation

extension String {
    // to convert to a string and add to the calendar maybe
    func convertToDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Verify the format")
        }
        return date
    }
    
    func convertToHeaderString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let transformedDate = formatter.date(from: self) else { return self}
        
        
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        let formatedDateString = formatter.string(from: transformedDate)
        
        return formatedDateString
    }
    
    func convertToRowTitle() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let transformDate = formatter.date(from: self) else { return self}
        
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        let formmatedRowString = formatter.string(from: transformDate)
        
        return formmatedRowString
    }
    
    func capitalizingFirstletter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstletter()
    }
    
}
