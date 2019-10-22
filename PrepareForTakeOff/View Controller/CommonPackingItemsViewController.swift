//
//  CommonPackingItemsViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/13/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class CommonPackingItemsViewController: UIViewController {

    @IBOutlet weak var commonItemsCollectionView: UICollectionView!
    
    @IBOutlet weak var addedConfirmationView: UIView!
    
    //var customItems = PackingWordBankController.shared.wordBank
    
    var selectedItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonItemsCollectionView.delegate = self
        commonItemsCollectionView.dataSource = self
        addedConfirmationView.alpha = 0
        addedConfirmationView.layer.masksToBounds = true
        addedConfirmationView.layer.cornerRadius = 10
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressRecognizer.minimumPressDuration = 1
        longPressRecognizer.delaysTouchesBegan = true
        longPressRecognizer.delegate = self
        self.commonItemsCollectionView.addGestureRecognizer(longPressRecognizer)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // this works
        self.commonItemsCollectionView.reloadData()
    }
    
    @IBAction func addCustomItemTapped(_ sender: UIBarButtonItem) {
        // ui aler pop up
        presentAddPackingItemAlert()
        
    }
    
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let trip = TripController.shared.tripForAllTabs else { return }
        let selectedItemsSetToArray = Array(Set(selectedItems))
        // add a check if the array is not empty if it is add a pop to say to add items
        if !selectedItemsSetToArray.isEmpty {
            for item in selectedItemsSetToArray {
                PackingComponentController.shared.add(itemWithName: item, trip: trip)
                //PackingWordBankController.shared.createPackingWordBank(reuseItem: item)
            }
            addedConfirmationView.alpha = 1
            UIView.animate(withDuration: 3, delay: 0, options: .curveEaseIn, animations: {
                self.addedConfirmationView.alpha = 0
            }) { (success) in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
           presentUIHelperAlert(title: "No items selected", message: "Please select items to add to Packing List")
        }
    
    }
    
    func presentAddPackingItemAlert() {
        let alertController = UIAlertController(title: "Add Packing Item", message: "Add to your custom bank", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter packing item..."
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .words
        }
        
        let addPackingItem = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let newPackingItem = alertController.textFields?.first?.text else { return }
            if !newPackingItem.isEmpty {
                PackingWordBankController.shared.createPackingWordBank(reuseItem: newPackingItem)
                DispatchQueue.main.async {
                    self.commonItemsCollectionView.reloadData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(addPackingItem)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
}

extension CommonPackingItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PackingWordBankController.shared.wordBank.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commonItem", for: indexPath) as? CommonItemCollectionViewCell else { return UICollectionViewCell() }
        let commonItem = PackingWordBankController.shared.wordBank[indexPath.row].reuseItem
       // let commonItem = customItems[indexPath.row].reuseItem
        
        cell.commonItemLabel.text = commonItem
        cell.commonItemLabel.layer.masksToBounds = true
        cell.commonItemLabel.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        // get user selected item from indexpath
        guard let commonItem = PackingWordBankController.shared.wordBank[indexPath.row].reuseItem else { return }
        //guard let commonItem = customItems[indexPath.row].reuseItem else { return }
        cell?.layer.masksToBounds = true
        cell?.layer.cornerRadius = 10
        
        if selectedItems.contains(commonItem) {
            cell?.backgroundColor = .clear
            if let index = selectedItems.firstIndex(of: commonItem) {
                selectedItems.remove(at: index)
            }
            print("Items selected are: \(selectedItems)")
        } else {
            cell?.backgroundColor = .systemTeal
            selectedItems.append(commonItem)
            print("Items selected are: \(selectedItems)")

        }

    }
    
    func presentUIHelperAlert(title: String, message: String) {
           
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
           alertController.addAction(okayAction)
           self.present(alertController, animated: true)
       }
}

extension CommonPackingItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ( collectionView.frame.size.width - 80 ) / 3,height:( collectionView.frame.size.width - 80 ) / 3)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
    }
}

extension CommonPackingItemsViewController: UIGestureRecognizerDelegate {
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let point = gestureRecognizer.location(in: self.commonItemsCollectionView)
        let indexPath = self.commonItemsCollectionView.indexPathForItem(at: point)
        if let index = indexPath {
       
            let item = PackingWordBankController.shared.wordBank[index.item]
            
            presentDeleteCellConfirmation(title: "Confirm Deletion", message: "Do you want to permananetly delete \(item.reuseItem!) ?", indexPath: index)
        }
    }
    
    func presentDeleteCellConfirmation(title: String, message: String, indexPath: IndexPath?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let index = indexPath {
            let cell = self.commonItemsCollectionView.cellForItem(at: index)
            cell?.layer.masksToBounds = true
            cell?.layer.cornerRadius = 10
            
            cell?.backgroundColor = .red
            cell?.alpha = 0.9
        }
        
        let noAction = UIAlertAction(title: "No, Keep.", style: .cancel) { (_) in
            if let index = indexPath {
                       let cell = self.commonItemsCollectionView.cellForItem(at: index)
                       cell?.layer.masksToBounds = true
                       cell?.layer.cornerRadius = 10
                       
                       cell?.backgroundColor = .clear
                      // cell?.alpha = 0.9
                   }
            
        }
        
        let deleteAction = UIAlertAction(title: "Yes, Delete.", style: .destructive) { (_) in
            if let index = indexPath {
               // let cell = self.commonItemsCollectionView.cellForItem(at: index)
//                cell?.layer.masksToBounds = true
//                cell?.layer.cornerRadius = 10
//                cell?.backgroundColor = .red
//                cell?.alpha = 0.9
                
                let itemToDelete = PackingWordBankController.shared.wordBank[index.item]
                
                PackingWordBankController.shared.delete(packingWordBank: itemToDelete)
                self.commonItemsCollectionView.deleteItems(at: [index])
                self.commonItemsCollectionView.reloadData()
                
            }
        }
        alertController.addAction(noAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true)
    }
}

