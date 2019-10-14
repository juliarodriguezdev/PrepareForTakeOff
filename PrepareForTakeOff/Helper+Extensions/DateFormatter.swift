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
}
