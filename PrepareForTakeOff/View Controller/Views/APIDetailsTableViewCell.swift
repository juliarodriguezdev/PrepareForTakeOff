//
//  APIDetailsTableViewCell.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 1/8/20.
//  Copyright © 2020 Julia Rodriguez. All rights reserved.
//

import UIKit

class APIDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    // update image
    @IBOutlet weak var apiButton: UIButton!
    
    var apiDetail: APIDetail?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateViews(apiObject: APIDetail) {
        titleLabel.text = apiObject.title
        descriptionLabel.text = apiObject.description
        apiButton.setBackgroundImage(UIImage(named: apiObject.logoImageName), for: .normal)
    }

    @IBAction func apiButtonTapped(_ sender: Any) {
        guard let singleApiDetail = apiDetail else { return }
        if let apiURL = URL(string: singleApiDetail.urlAsString) {
         
            UIApplication.shared.open(apiURL) { (success) in
                print("Sent to \(singleApiDetail.title) website")
            }
        }
    }
    

}
