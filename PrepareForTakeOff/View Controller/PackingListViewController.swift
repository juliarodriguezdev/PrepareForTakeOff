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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        packingTableView.delegate = self
        packingTableView.dataSource = self
        self.title = trip?.name

    }
    
    @IBAction func addPackingItemTapped(_ sender: UIBarButtonItem) {
        // navigate to the packing bank VC
    }
    
    @IBAction func editTripButtonTapped(_ sender: UIButton) {
        // navigate to edit trip details VC
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
    
    // add did select row a func to toggle the isChecked Bool on/off, and upate the checkbox / checkmark
    
}