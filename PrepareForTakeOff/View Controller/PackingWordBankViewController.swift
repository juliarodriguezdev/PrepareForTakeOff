//
//  PackingWordBankViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/13/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit
//import QuartzCore

class PackingWordBankViewController: UIViewController, UITextFieldDelegate {

   // static let shared = PackingWordBankViewController()
    
    @IBOutlet weak var wordBankCollectionView: UICollectionView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var addedConfirmationView: UIView!
    
    //var trip: Trip?
    
    // source of truth
    var selectionPackingItems: [String]?

    var itemsForTrip: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBankCollectionView.delegate = self
        wordBankCollectionView.dataSource = self
        addedConfirmationView.alpha = 0
        addedConfirmationView.layer.masksToBounds = true
        addedConfirmationView.layer.cornerRadius = 10
     
       // title = trip?.name
    

    }
    
    @IBAction func addToPackingListButtonTapped(_ sender: UIButton) {
        guard let trip = TripController.shared.tripForAllTabs else { return }
        let itemsSet = Array(Set(itemsForTrip))
        for item in itemsSet {
            PackingComponentController.shared.add(itemWithName: item, trip: trip)
        }
        
        addedConfirmationView.alpha = 1
        UIView.animate(withDuration: 0, delay: 3, options: .curveEaseIn, animations: {
            self.addedConfirmationView.alpha = 0
        }) { (success) in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wordBankCollectionView.reloadData()
    }
    
}
extension PackingWordBankViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return PackingWordBankController.shared.wordBank.count
        guard let userSelectedItems = selectionPackingItems else { return 0}
        return userSelectedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wordBankCell", for: indexPath) as? PackingWordBankCollectionViewCell else { return UICollectionViewCell() }
        guard let userSelectedItems = selectionPackingItems else { return cell }
        let wordBankItem = userSelectedItems[indexPath.row]
        //let wordBankItem = PackingWordBankController.shared.wordBank[indexPath.row]
        cell.wordBankLabel.text = wordBankItem
        cell.wordBankLabel.layer.masksToBounds = true
        cell.wordBankLabel.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        guard let userSelectedItems = selectionPackingItems else { return }
        let packingItem = userSelectedItems[indexPath.row]
       // let packingItem = PackingWordBankController.shared.wordBank[indexPath.row]
        //guard let newPackingItem = packingItem else { return }
        cell?.layer.masksToBounds = true
        cell?.layer.cornerRadius = 10
        
        if itemsForTrip.contains(packingItem) {
            
            cell?.backgroundColor = .clear
            if let index = itemsForTrip.firstIndex(of: packingItem) {
                itemsForTrip.remove(at: index)
                
            }
            
        } else {
            cell?.backgroundColor = .systemTeal
            itemsForTrip.append(packingItem)
        }
    }
    
}
extension PackingWordBankViewController: UICollectionViewDelegateFlowLayout {
    
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

