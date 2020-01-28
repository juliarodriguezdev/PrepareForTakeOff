//
//  PackingListViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/13/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class PackingListViewController: UIViewController {

    // landing pad
    var trip: Trip?
    
    var packingListWithSections = [String: [String]]()
    var packingSectionTitle = [String]()
    
    // set up with trip name from previous screen
    @IBOutlet weak var tripNameLabel: UILabel!
    
    @IBOutlet weak var packingTableView: UITableView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var packingStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        packingTableView.delegate = self
        packingTableView.dataSource = self
        self.view.backgroundColor = UIColor.travelBackground
        self.packingTableView.backgroundColor = UIColor.travelBackground
        self.tabBarController?.tabBar.isHidden = false
    
        updateCountDownView()
        updatePackedItems()
        createSectionPackingList()
        guard let trip = trip?.name else { return }
        self.tripNameLabel.text = "\(trip)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
       
        updateCountDownView()
        updatePackedItems()
        createSectionPackingList()
        self.packingTableView.reloadData()
    }
    
   
    @IBAction func editTripButtonTapped(_ sender: UIButton) {
        // navigate to edit trip details VC
        navigateToEditVC()
    }
    
    @IBAction func addItemsButtonTapped(_ sender: UIButton) {
        // send to new storyboard to add items
        navigateToAddItemsViewController()
    }
    @IBAction func packingListButtonTapped(_ sender: Any) {
        navigateToAddItemsViewController()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func acknowledgmentsButtonTapped(_ sender: Any) {
         navigateToAcknowledgementsVC()
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
                if totalPackingList.count == 1 {
                    self.packingStatusLabel.text = "\(totalPackingList.count) item to pack"
                } else {
                    self.packingStatusLabel.text = "\(totalPackingList.count) items to pack"
                }
                
            } else if packedItems.count == totalPackingList.count {
                if packedItems.count == 1 {
                    self.packingStatusLabel.text = "Single item is packed"
                } else {
                    self.packingStatusLabel.text = "All \(totalPackingList.count) items are packed"
                    
                }
                
            } else if packedItems.count == totalPackingList.count - 1 {
                self.packingStatusLabel.text = "\(packedItems.count) / \(totalPackingList.count) packed, you are almost done"
            } else {
                self.packingStatusLabel.text = "\(packedItems.count) / \(totalPackingList.count) items packed"
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
    
    func navigateToAddItemsViewController() {
        let storyboard = UIStoryboard(name: "Trip", bundle: nil)
        guard let addItemsViewController = storyboard.instantiateViewController(withIdentifier: "PackingCategoriesViewController") as? PackingCategoriesViewController else { return }
        addItemsViewController.trip = trip
        self.navigationController?.pushViewController(addItemsViewController, animated: true)
    }
    func navigateToEditVC() {
        let storyboard = UIStoryboard(name: "Trip", bundle: nil)
        guard let editTripViewController = storyboard.instantiateViewController(withIdentifier: "EditTripViewController") as? EditTripViewController else { return }
        // maybe pass variable
        editTripViewController.trip = trip
        self.navigationController?.pushViewController(editTripViewController, animated: true)
    }
    
    func navigateToAcknowledgementsVC() {
        let storyboard = UIStoryboard(name: "Trip", bundle: nil)
        guard let acknowledgementsViewController = storyboard.instantiateViewController(withIdentifier: "AcknowledgmentViewController") as? AcknowledgmentViewController else { return }
        self.navigationController?.pushViewController(acknowledgementsViewController, animated: true)
    }

}

extension PackingListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return packingSectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let frame = CGRect(x: 0, y: 0, width: (self.view.frame.size.width) * 0.90, height:52 ) //(self.view.frame.size.height) * 0.1)
        let myCustomView = UIImageView(frame: frame)
        let myImage: UIImage = UIImage(named: "95300299-torn-paper-ribbons-with-jagged-edges-abstract-grange-paper-sheets-vector-set-ripped-paper-design-ban")!
        myCustomView.image = myImage
        myCustomView.contentMode = .scaleToFill
       // myCustomView.translatesAutoresizingMaskIntoConstraints = false
        
        
        header.addSubview(myCustomView)
        let frameLabel = CGRect(x: 15, y: 0, width: (self.view.frame.size.width) * 0.90, height: 52)
        let headerLabel = UILabel(frame: frameLabel)
        headerLabel.textColor = .black
        headerLabel.font = UIFont(name: FontNames.fingerPaintRegular, size: 20)
        headerLabel.textAlignment = .left
        if packingSectionTitle.count > section {
            headerLabel.text = packingSectionTitle[section]
        } else {
            headerLabel.text = ""
        }
        header.addSubview(headerLabel)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = packingListWithSections[packingSectionTitle[section]]
        return item?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "packingListCell", for: indexPath) as? PackingListTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = UIColor.travelBackground
        cell.selectionStyle = .none
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
           
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            UIView.animate(withDuration: 2.8, delay: 0, options: .curveLinear, animations: {
                self.createSectionPackingList()
                tableView.reloadData()
                
            })
            
           
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
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
