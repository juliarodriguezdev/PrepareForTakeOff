//
//  PackingCategoriesViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/21/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class PackingCategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PackingCategories.shared.categoryKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = PackingCategories.shared.categoryKeys[indexPath.row]
        cell.textLabel?.text = category
        
        return cell 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWordBankVC" {
            
            
            if let destinationVC = segue.destination as? PackingWordBankViewController,
                let indexPath = categoriesTableView.indexPathForSelectedRow {
                
                let packingKey = PackingCategories.shared.categoryKeys[indexPath.row]
                let packingValues = PackingCategories.shared.categories[packingKey]
                destinationVC.selectionPackingItems = packingValues
            }
            
        }
    }
    
    
    
}
