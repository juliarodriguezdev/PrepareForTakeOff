//
//  PackingWordBankViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/13/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class PackingWordBankViewController: UIViewController {

    @IBOutlet weak var wordBankCollectionView: UICollectionView!
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBankCollectionView.delegate = self
        wordBankCollectionView.dataSource = self

    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
    }
    @IBAction func lookupButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toCommonItem", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wordBankCollectionView.reloadData()
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
    
}
