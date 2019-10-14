//
//  Trip+Convenience.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/9/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation
import CoreData

extension Trip {
    
    @discardableResult
    
    convenience init(date: Date, destinationCity: String, destinationCountryCode: String, destinationCountryName: String, destinationCurrencyCode: String, destinationStateCode: String?, inUSA: Bool, name: String, userCurrencyCode: String, context: NSManagedObjectContext = CoreDataStack.managedObjectContext){
        
        self.init(context: context)
        self.date = date
        self.destinationCity = destinationCity
        self.destinationCountryCode = destinationCountryCode
        self.destinationCountryName = destinationCountryName
        self.destinationCurrencyCode = destinationCurrencyCode
        self.destinationStateCode = destinationStateCode
        self.inUSA = inUSA
        self.name = name
        self.userCurrencyCode = userCurrencyCode
    }
}
