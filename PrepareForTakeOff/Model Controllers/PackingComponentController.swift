//
//  PackingListController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/11/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation
import CoreData

class PackingComponentController {
    
    static let shared = PackingComponentController()
    
   
    func add(itemWithName packingItem: String, isComplete: Bool = false, trip: Trip) {
        PackingComponent(packingItem: packingItem, isComplete: isComplete, trip: trip)
        // save to persistence store
        TripController.shared.saveToPersistentStore()
    }
    
    // Does this need to reference the trip?
    func update(packingItem: PackingComponent, item: String, isComplete: Bool) {
        packingItem.packingItem = item
        packingItem.isComplete = isComplete
        // save to persistent store
        TripController.shared.saveToPersistentStore()
    }
    
    func delete(packingItem: PackingComponent) {
        if let moc = packingItem.managedObjectContext {
            moc.delete(packingItem)
            // save to persistent store
            TripController.shared.saveToPersistentStore()
        }
    }
    
    func toggleIsCompleteFor(packingComponent: PackingComponent) {
        packingComponent.isComplete = !packingComponent.isComplete
        TripController.shared.saveToPersistentStore()
    }
    
}
