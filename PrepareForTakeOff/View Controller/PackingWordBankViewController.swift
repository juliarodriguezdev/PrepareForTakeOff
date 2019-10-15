//
//  PackingWordBankViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/13/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class PackingWordBankViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var wordBankCollectionView: UICollectionView!
    
    @IBOutlet weak var addButton: UIButton!
    
    var trip: Trip?
    
    var itemsForTrip: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBankCollectionView.delegate = self
        wordBankCollectionView.dataSource = self
        //wordBankCollectionView.allowsMultipleSelection = true
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressRecognizer.minimumPressDuration = 1
        longPressRecognizer.delaysTouchesBegan = true
        longPressRecognizer.delegate = self
        self.wordBankCollectionView.addGestureRecognizer(longPressRecognizer)
        title = trip?.name
    

    }
    
    
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        // alert controller pop up to add item
        presentAddPackingItemAlert()
        // reload collection view after something is added
    }

    @IBAction func lookupButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toCommonItem", sender: self)
    }
    @IBAction func addToPackingListButtonTapped(_ sender: UIButton) {
        guard let trip = trip else { return }
        let itemsSet = Array(Set(itemsForTrip))
        for item in itemsSet {
            PackingComponentController.shared.add(itemWithName: item, trip: trip)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wordBankCollectionView.reloadData()
    }
    
    func presentAddPackingItemAlert() {
        let alertController = UIAlertController(title: "Add Packing Item", message: "Add to your collection bank", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter packing item..."
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .words
            textField.delegate = self
        }
        
        let addPackingItem = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let newPackingItem = alertController.textFields?.first?.text else { return }
            if !newPackingItem.isEmpty {
                // check if it not already in the index of the items
                PackingWordBankController.shared.createPackingWordBank(reuseItem: newPackingItem)
                DispatchQueue.main.async {
                    self.wordBankCollectionView.reloadData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(addPackingItem)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PackingWordBankViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PackingWordBankController.shared.wordBank.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wordBankCell", for: indexPath) as? PackingWordBankCollectionViewCell else { return UICollectionViewCell() }
        
        let wordBankItem = PackingWordBankController.shared.wordBank[indexPath.row]
        cell.wordBankLabel.text = wordBankItem.reuseItem
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        let packingItem = PackingWordBankController.shared.wordBank[indexPath.row]
        guard let newPackingItem = packingItem.reuseItem else { return }
        
        if itemsForTrip.contains(newPackingItem) {
            
            // deselect and remove item
            cell?.backgroundColor = .clear
            if let index = itemsForTrip.firstIndex(of: newPackingItem) {
                itemsForTrip.remove(at: index)
            }
            //return
            
        } else {
            cell?.backgroundColor = .cyan
            itemsForTrip.append(newPackingItem)
        }
        //return
    }
    
}

extension PackingWordBankViewController: UIGestureRecognizerDelegate {
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let point = gestureRecognizer.location(in: self.wordBankCollectionView)
        let indexPath = self.wordBankCollectionView.indexPathForItem(at: point)
        if let index = indexPath {
            let cell = self.wordBankCollectionView.cellForItem(at: index)
            
            cell?.backgroundColor = .red
            cell?.contentView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            let item = PackingWordBankController.shared.wordBank[index.item]
            
            presentDeleteCellConfirmation(title: "Confirm Deletion", message: "Do you want to permananetly delete \(item.reuseItem!)) ?", indexPath: indexPath)
        }
    }
    
    func presentDeleteCellConfirmation(title: String, message: String, indexPath: IndexPath?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No, Keep.", style: .cancel) { (_) in
            if let index = indexPath {
                let cell = self.wordBankCollectionView.cellForItem(at: index)
                cell?.backgroundColor = .clear
                cell?.contentView.transform = .identity
            }
            
        }
        
        let deleteAction = UIAlertAction(title: "Yes, Delete.", style: .destructive) { (_) in
            if let index = indexPath {
                let itemToDelete = PackingWordBankController.shared.wordBank[index.item]
                PackingWordBankController.shared.delete(packingWordBank: itemToDelete)
                DispatchQueue.main.async {
                    self.wordBankCollectionView.deleteItems(at: [index])
                    self.wordBankCollectionView.reloadData()
                }
            }
        }
        alertController.addAction(noAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true)
    }
}
