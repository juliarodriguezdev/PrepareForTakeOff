//
//  PackingListTableViewCell.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/13/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class PackingListTableViewCell: UITableViewCell {

    @IBOutlet weak var isCheckedButton: UIButton!
    
    @IBOutlet weak var packingItemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateViews(with packingitem: PackingComponent) {
        packingItemLabel.text = packingitem.packingItem
        let imageName = packingitem.isComplete ? "Packing_checkMark" : "Packing_checkBox_rounded"
        isCheckedButton.setImage(UIImage(named: imageName), for: .normal)
        
//        if packingitem.isComplete == true {
//            isCheckedButton.setImage(UIImage(named: "Packing_checkMark"), for: .normal)
//        } else {
//            isCheckedButton.setImage(UIImage(named: "Packing_checkBox_rounded"), for: .normal)
//        }
        
    }

}
