//
//  PackingListViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/13/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class PackingListViewController: UIViewController {

    var trip: Trip?
    
    @IBOutlet weak var packingTableView: UITableView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        packingTableView.delegate = self
        packingTableView.dataSource = self
        self.tabBarController?.tabBar.isHidden = false
        self.title = "Let's Pack"
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.packingTableView.reloadData()
    }
    
    @IBAction func addPackingItemTapped(_ sender: UIBarButtonItem) {
        // navigate to the packing bank VC
        
    }
    
    @IBAction func editTripButtonTapped(_ sender: UIButton) {
        // navigate to edit trip details VC
    }
    func updateViews() {
        guard let trip = trip else { return }
        // TODO: Add progress, iscomplete / total item 
        if let tripName = trip.name {
         infoLabel.text = "Packlist for upcoming: \(tripName)"

        } else {
            infoLabel.text = "Packing list for upcoming tirp "
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? PackingWordBankViewController else { return }
        let trip = self.trip
        destinationVC.trip = trip
    }


}

extension PackingListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trip?.packingList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "packingListCell", for: indexPath) as? PackingListTableViewCell else { return UITableViewCell() }
        
        guard let packingItem = trip?.packingList?[indexPath.row] as? PackingComponent else { return UITableViewCell() }
        // call update views
        cell.updateViews(with: packingItem)

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let packingItem = trip?.packingList?[indexPath.row] as? PackingComponent else { return }
            // delete from source of truth
            PackingComponentController.shared.delete(packingItem: packingItem)
            // delete from tableview
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // add did select row a func to toggle the isChecked Bool on/off, and upate the checkbox / checkmark
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let packingComponent = trip?.packingList?[indexPath.row] as? PackingComponent {
            PackingComponentController.shared.toggleIsCompleteFor(packingComponent: packingComponent)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
}
