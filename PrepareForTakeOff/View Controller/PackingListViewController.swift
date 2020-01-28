//
//  PackingListViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/13/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class PackingListViewController: UIViewController {

    var trip: Trip?
    
    var packingListWithSections = [String: [String]]()
    var packingSectionTitle = [String]()
    
    @IBOutlet weak var packingTableView: UITableView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var packingStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        packingTableView.delegate = self
        packingTableView.dataSource = self
        self.tabBarController?.tabBar.isHidden = false
        guard let trip = trip?.name else { return }
        self.title = "\(trip)"
        updateCountDownView()
        updatePackedItems()
        createSectionPackingList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCountDownView()
        updatePackedItems()
        createSectionPackingList()
        self.packingTableView.reloadData()
    }
    
   
    @IBAction func editTripButtonTapped(_ sender: UIButton) {
        // navigate to edit trip details VC
    }
    func updateCountDownView() {
        // TODO: Add progress, iscomplete / total item
        guard let tripDate = trip?.date else { return }
        let today = Date()
        let destinationDate = tripDate
        
        let components = Calendar.current.dateComponents([.day], from: today, to: destinationDate)
        guard let countdown = components.day else { return }
        if countdown > 0 {
            infoLabel.text = "\(countdown) days until take off!"
            
        } else if countdown == 0 {
            infoLabel.text = "Your trip is today!"
        } else {
            infoLabel.text = ""
        }
    }
   
    func updatePackedItems() {
      //  var totalPacked: Int = 0
        guard let totalPackingList = trip?.packingList else { return }
        
        let packedItems = totalPackingList.map({$0 as? PackingComponent}).filter({$0?.isComplete == true})
        
        UIView.animate(withDuration: 0.5) {
            if totalPackingList.count == 0 {
                self.packingStatusLabel.text = "Add items to your packing list it's empty"
            } else if packedItems.count == 0 && totalPackingList.count > 0 {
                self.packingStatusLabel.text = "\(totalPackingList.count) items to pack"
            } else if packedItems.count == totalPackingList.count {
                self.packingStatusLabel.text = "Good job on packing all \(totalPackingList.count) items"
            } else if packedItems.count == totalPackingList.count - 1 {
                self.packingStatusLabel.text = "\(packedItems.count) / \(totalPackingList.count) packed, you are almost done"
            } else {
                self.packingStatusLabel.text = "\(packedItems.count) / \(totalPackingList.count) items already packed"
            }
            
        }
    }
    
    func createSectionPackingList() {
        guard let packingList = trip?.packingList else { return }
        
        let items = packingList.map({$0 as? PackingComponent})
        
        let packingitems = items.compactMap({$0?.packingItem})
        
        var foundItemsDictionary = [String: [String]]()
        
        for item in packingitems {
            
            let masterCategoryList = PackingCategories.shared.categories
            for (key, value) in masterCategoryList {
                if value.contains(item) {
                    foundItemsDictionary[key, default: []].append(item)
                }
            }
            let masterCustomCategoriesList = PackingWordBankController.shared.wordBank
            let itemsInCustomCategories = masterCustomCategoriesList.compactMap({$0.reuseItem})
            if itemsInCustomCategories.contains(item) {
                
                foundItemsDictionary["Custom", default: []].append(item)
            }

        }
        packingListWithSections = foundItemsDictionary
        packingSectionTitle = packingListWithSections.keys.sorted()
    }

}

extension PackingListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return packingSectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.backgroundColor = .systemIndigo
        headerLabel.textColor = .black
        headerLabel.textAlignment = .center
        if packingSectionTitle.count > section {
            headerLabel.text = packingSectionTitle[section]
        } else {
            headerLabel.text = ""
        }
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return trip?.packingList?.count ?? 0
        let item = packingListWithSections[packingSectionTitle[section]]
        return item?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "packingListCell", for: indexPath) as? PackingListTableViewCell else { return UITableViewCell() }
        
        let sections = packingSectionTitle[indexPath.section]
        let packingItem = packingListWithSections[sections]?[indexPath.row]
        if let packingStringItem = packingItem {
            
            cell.updateViews(packingitem: packingStringItem)
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sections = packingSectionTitle[indexPath.section]
            let itemToPack = packingListWithSections[sections]?[indexPath.row]
            guard let packingList = TripController.shared.tripForAllTabs?.packingList else { return }
            let packingListCasted = packingList.compactMap({$0 as? PackingComponent})
            for item in packingListCasted {
                if item.packingItem == itemToPack {
                    PackingComponentController.shared.delete(packingItem: item)
                }
            }
            createSectionPackingList()
            tableView.reloadData()
           
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
 
}
extension PackingListViewController: PackingListDelegate {
    
    func packingItemToggled(for sender: PackingListTableViewCell, withTitle title: String) {
        let packingItemSelected = title
        
        guard let packingList = TripController.shared.tripForAllTabs?.packingList else { return }
        let packingItems = packingList.compactMap({$0 as? PackingComponent})
        
        let itemTapped = packingItems.filter({$0.packingItem == packingItemSelected})
        if let selectedPackingComponent = itemTapped.first {
            
            PackingComponentController.shared.toggleIsCompleteFor(packingComponent: selectedPackingComponent)
            sender.updateCheckBox(item: selectedPackingComponent)
            updatePackedItems()
        }
    }
    
    
}
