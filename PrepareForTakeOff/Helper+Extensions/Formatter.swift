//
//  Formatter.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/19/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}



