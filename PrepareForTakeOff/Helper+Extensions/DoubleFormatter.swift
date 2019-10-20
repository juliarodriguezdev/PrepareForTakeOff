//
//  Formatter.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/19/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation

extension Double {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
