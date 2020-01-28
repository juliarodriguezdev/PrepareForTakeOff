//
//  AcknowledgmentViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 1/7/20.
//  Copyright © 2020 Julia Rodriguez. All rights reserved.
//

import UIKit

class AcknowledgmentViewController: UIViewController {
    
    @IBOutlet weak var designerNameLabel: UILabel!
    
    @IBOutlet weak var designerDescriptionLabel: UILabel!
    
    @IBOutlet weak var apiTableView: UITableView!
    
   // @IBOutlet weak var iconsTableView: UITableView!
    @IBOutlet weak var iconTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.travelBackground
        apiTableView.backgroundColor = UIColor.travelBackground
        iconTableView.backgroundColor = UIColor.travelBackground
        UXDesginerController.shared.loadUXDesignerDetails()
        APIDetailController.shared.loadAPIDetails()
        IconDetailController.shared.loadIconDetails()
        
        apiTableView.delegate = self
        apiTableView.dataSource = self
        
        iconTableView.delegate = self
        iconTableView.dataSource = self
        
        loadUXDesignerDetails()
    }
    
    func loadUXDesignerDetails() {
        designerNameLabel.text = UXDesginerController.shared.sageDetails.nameAndTitle
        designerDescriptionLabel.text = UXDesginerController.shared.sageDetails.description
    }
    
    @IBAction func mediumButtonTapped(_ sender: Any) {
        // navigate to Sage's medium articles
        let mediumString = UXDesginerController.shared.sageDetails.mediumURL
        guard let mediumURL = URL(string: mediumString) else { return }
        UIApplication.shared.open(mediumURL) { (success) in
            if success {
                print("Sent to UX Designers Medium page")
            }
        }
    }
    
    @IBAction func linkedinButtonTapped(_ sender: Any) {
        let linkedinString = UXDesginerController.shared.sageDetails.linkedinURL
        guard let linkedinURL = URL(string: linkedinString) else { return }
        UIApplication.shared.open(linkedinURL) { (success) in
            if success {
                print("sent to UX Designers Linkedin page")
            }
        }
    }
}

extension AcknowledgmentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        if tableView == apiTableView {
            height = 100
        } else if tableView == iconTableView {
            height = 45
        }
        return height
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == apiTableView {
            count = APIDetailController.shared.apiDetails.count
        } else if tableView == iconTableView {
            count = IconDetailController.shared.iconAttributions.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == apiTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "apiDetailsCell", for: indexPath) as? APIDetailsTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = UIColor.travelBackground
            let singleAPI = APIDetailController.shared.apiDetails[indexPath.row]
            
            cell.updateViews(apiObject: singleAPI)
            cell.apiDetail = singleAPI
            
            return cell
            
        } else if tableView == iconTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "iconCell", for: indexPath) as? IconDetailTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = UIColor.travelBackground
            cell.textLabel?.textColor = .black
            let icon = IconDetailController.shared.iconAttributions[indexPath.row]
            cell.iconLabel.text = icon.iconCredit
            cell.iconLabel.font = UIFont(name: FontNames.nunitoLight, size: 13)
            return cell
        }
        return UITableViewCell()
    }
}
