//
//  PackingWordBank+Convenience.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/11/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation
import CoreData

extension PackingWordBank {
    
    @discardableResult
    
    convenience init(reuseItem: String, context: NSManagedObjectContext = CoreDataStack.managedObjectContext) {
        self.init(context: context)
        self.reuseItem = reuseItem
        //self.packingComponent = packingComponent
    }
}
