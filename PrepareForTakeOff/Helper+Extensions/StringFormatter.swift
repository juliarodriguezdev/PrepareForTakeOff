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
}
