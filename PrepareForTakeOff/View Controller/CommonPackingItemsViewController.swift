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
    
    var commonItems: [String] = ["Shampoo", "Conditioner", "Comb", "Soap", "Facial Cleanser", "Loofa", "Wash cloth", "Body Lotion", "Face Lotion", "Q-tips", "Deodorant", "Sunscreen", "Bug Repellant", "Sunglases","Shaving Cream", "Razor", "Tooth paste", "Tooth brush", "Floss", "Hair spray", "Hair mousse", "Hair gel", "Phone Charger", "Camera"]
    
    var selectedItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonItemsCollectionView.delegate = self
        commonItemsCollectionView.dataSource = self
        commonItemsCollectionView.allowsMultipleSelection = true

    }
    // allow multiple selections
    // change the background color of the selected items
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        // call create func from PackingWordBank Controller, on the items selected
        let selectedItemsSetToArray = Array(Set(selectedItems))
        for item in selectedItemsSetToArray {
            PackingWordBankController.shared.createPackingWordBank(reuseItem: item)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension CommonPackingItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commonItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commonItem", for: indexPath) as? CommonItemCollectionViewCell else { return UICollectionViewCell() }
        
        let commonItem = commonItems[indexPath.row]
        cell.commonItemLabel.text = commonItem
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        // get user selected item from indexpath
        let commonItem = commonItems[indexPath.row]
        if cell?.isSelected == true {
            cell?.backgroundColor = .cyan
            selectedItems.append(commonItem)
            
        } else if cell?.isHighlighted == true {
            
            cell?.backgroundColor = .blue
        } else {
            cell?.backgroundColor = .clear
        }
    }
    
    
}
