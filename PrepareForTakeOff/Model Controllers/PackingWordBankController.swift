//
//  PackingWordBankController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/11/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation
import CoreData

class PackingWordBankController {
    
    static let shared = PackingWordBankController()
    
    var wordBank: [PackingWordBank]
    {
        let request: NSFetchRequest<PackingWordBank> = PackingWordBank.fetchRequest()
        
        return (try? CoreDataStack.managedObjectContext.fetch(request)) ?? []
    }
    func createPackingWordBank(reuseItem: String) {
        PackingWordBank(reuseItem: reuseItem)
        // save to persistent store
        saveToPersistentStore()
    }
    
    func delete(packingWordBank: PackingWordBank) {
        if let moc = packingWordBank.managedObjectContext {
            moc.delete(packingWordBank)
            // save to persistent store
            saveToPersistentStore()
        }
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.managedObjectContext
        do {
            try moc.save()
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")

        }
    }
}
