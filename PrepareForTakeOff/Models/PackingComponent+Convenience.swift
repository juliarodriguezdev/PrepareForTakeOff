//
//  PackingList+Convenience.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/11/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation
import CoreData

extension PackingComponent {
    
    @discardableResult
    
    convenience init(packingItem: String, isComplete: Bool, trip: Trip, context: NSManagedObjectContext = CoreDataStack.managedObjectContext) {
        self.init(context: context)
        self.packingItem = packingItem
        self.isComplete = isComplete
        self.trip = trip
    }
}
