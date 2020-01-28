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
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var wordBankCollectionView: UICollectionView!
    
    @IBOutlet weak var addButton: GrayButton!
    
    @IBOutlet weak var addedConfirmationView: UIView!
    
    @IBOutlet weak var statusBackground: UIImageView!
    
    @IBOutlet weak var packingStatusLabel: UILabel!
    
    
    var trip: Trip?
    var packingTitle: String?
    var selectionPackingItems: [String]?

    var itemsForTrip: [String] = [] {
        didSet {
            self.showPackingStatusUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBankCollectionView.delegate = self
        wordBankCollectionView.dataSource = self
        self.view.backgroundColor = UIColor.travelBackground
        wordBankCollectionView.backgroundColor = UIColor.travelBackground
        addedConfirmationView.alpha = 0
        addedConfirmationView.layer.masksToBounds = true
        addedConfirmationView.layer.cornerRadius = 10
        self.tabBarController?.tabBar.isHidden = false 
        if
            let specificTitle = packingTitle {
            nameLabel.text = specificTitle
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.isHidden = false
        wordBankCollectionView.reloadData()
        self.showPackingStatusUpdate()
    }
    
    @IBAction func addToPackingListButtonTapped(_ sender: UIButton) {
        backButton.isHidden = true
        guard let trip = TripController.shared.tripForAllTabs,
            let packingList = TripController.shared.tripForAllTabs?.packingList
        else { return }
        
        let itemsSet = Array(Set(itemsForTrip))
        let packingItems = packingList.map({$0 as? PackingComponent}).compactMap({$0?.packingItem})
        
        
        if !itemsSet.isEmpty {
            for item in itemsSet {
                if packingItems.contains(item) == false {
                    PackingComponentController.shared.add(itemWithName: item, trip: trip)
                } else {
                    print("Duplicate item is: \(item)")
                }
            }
            
        }
        
        addedConfirmationView.alpha = 1
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
            self.addedConfirmationView.alpha = 0
        }) { (success) in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showPackingStatusUpdate() {
        if itemsForTrip.isEmpty {
            statusBackground.isHidden = true
            packingStatusLabel.isHidden = true
        } else {
            statusBackground.isHidden = false
            packingStatusLabel.isHidden = false
            if itemsForTrip.count == 1 {
                self.packingStatusLabel.text = "You have selected \(self.itemsForTrip.count) item \nto add to your list"
            } else {
                self.packingStatusLabel.text = "You have selected \(self.itemsForTrip.count) items \nto add to your list"
            }
        }
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
        cell.backgroundColor = UIColor.travelBackground
        guard let userSelectedItems = selectionPackingItems else { return cell }
        let wordBankItem = userSelectedItems[indexPath.row]
        
        cell.wordBankLabel.text = wordBankItem
        cell.wordBankLabel.layer.masksToBounds = true
        cell.wordBankLabel.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        guard let userSelectedItems = selectionPackingItems else { return }
        let packingItem = userSelectedItems[indexPath.row]
        cell?.layer.masksToBounds = true
        cell?.layer.cornerRadius = 10
        
        if itemsForTrip.contains(packingItem) {
            
            cell?.backgroundColor = .clear
            if let index = itemsForTrip.firstIndex(of: packingItem) {
                itemsForTrip.remove(at: index)
                
            }
            
        } else {
            cell?.backgroundColor = .darkGray
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
          return CGSize(width: ( collectionView.frame.size.width - 45 ) / 3,height:( collectionView.frame.size.width - 45 ) / 3)
      }


      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 3, bottom: 8, right: 3)
      }
}

