//
//  PackingListTableViewCell.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/13/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

protocol PackingListDelegate: class {
    //func packingItemToggled(for sender: PackingListTableViewCell)

  func packingItemToggled(for sender: PackingListTableViewCell, withTitle title: String)
}

class PackingListTableViewCell: UITableViewCell {

    weak var delegate: PackingListDelegate?
    
    @IBOutlet weak var isCheckedButton: UIButton!
    
    @IBOutlet weak var packingItemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: Any) {
        guard let title = packingItemLabel.text else { return }
        delegate?.packingItemToggled(for: self, withTitle: title)
        //delegate?.packingItemToggled(for: self)

    }
    

    func updateViews(packingitem: String) {
       packingItemLabel.text = packingitem
        
        guard let packingList = TripController.shared.tripForAllTabs?.packingList else { return }
        let itemInList = packingList.map({$0 as? PackingComponent})
        
        for item in itemInList {
            if item?.packingItem == packingitem {
                
                if item?.isComplete == true {
                    isCheckedButton.setImage(UIImage(named: "Packing_checkMark"), for: .normal)
                } else {
                    isCheckedButton.setImage(UIImage(named: "Packing_checkBox_rounded"), for: .normal)
                }
            }
        }
        
        //let imageName = packingitem.isComplete ? "Packing_checkMark" : "Packing_checkBox_rounded"
        //isCheckedButton.setImage(UIImage(named: imageName), for: .normal)
        
    }
    
    func updateCheckBox(item: PackingComponent) {
        let imagename = item.isComplete ? "Packing_checkMark" : "Packing_checkBox_rounded"
        isCheckedButton.setImage(UIImage(named: imagename), for: .normal)
    }

}


