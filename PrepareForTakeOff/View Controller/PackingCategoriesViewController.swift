//
//  PackingCategoriesViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/21/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class PackingCategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var trip: Trip?
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    @IBOutlet weak var customItemsButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        self.view.backgroundColor = UIColor.travelBackground
        self.categoriesTableView.backgroundColor = UIColor.travelBackground
        self.tabBarController?.tabBar.isHidden = false
        customItemsButton.setTitle("   Add Custom", for: .normal)
        if let trip = trip?.name {
            nameLabel.text = trip
        }
        // get title from trip name
    }
    
    @IBAction func customButtonTapped(_ sender: Any) {
        showCustomItemsViewController()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showCustomItemsViewController() {
        let storyboard = UIStoryboard(name: "Trip", bundle: nil)
        guard let customItemsViewController = storyboard.instantiateViewController(withIdentifier: "CommonPackingItemsViewController") as? CommonPackingItemsViewController else { return }
        customItemsViewController.trip = trip
        self.navigationController?.pushViewController(customItemsViewController, animated: true)
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PackingCategories.shared.categoryKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.backgroundColor = UIColor.travelBackground
        cell.selectionStyle = .none
        let category = PackingCategories.shared.categoryKeys[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont(name: FontNames.fingerPaintRegular, size: 24)
        cell.textLabel?.text = category
        
        return cell 
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = categoriesTableView.indexPathForSelectedRow {
            let packingKey = PackingCategories.shared.categoryKeys[indexPath.row]
            let packingValues = PackingCategories.shared.categories[packingKey]
            // navigate to next view controller
            let storyboard = UIStoryboard(name: "Trip", bundle: nil)
            guard let packingBankViewController = storyboard.instantiateViewController(withIdentifier: "PackingWordBankViewController") as? PackingWordBankViewController else { return }
            packingBankViewController.packingTitle = packingKey
            packingBankViewController.selectionPackingItems = packingValues
            
            self.navigationController?.pushViewController(packingBankViewController, animated: true)
            
        }
    }
}
