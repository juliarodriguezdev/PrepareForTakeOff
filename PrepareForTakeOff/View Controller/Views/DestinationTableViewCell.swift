//
//  DestinationTableViewCell.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/16/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class DestinationTableViewCell: UITableViewCell {
    
    var destinationInfo: DestinationInfo?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var snippetLabel: UILabel!
        
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self 
    }
    func updateViews() {
        guard let destinationInfo = destinationInfo else { return }
        nameLabel.text = destinationInfo.name
        scoreLabel.text = "Score: " + String(format: "%.2f", destinationInfo.score)
        snippetLabel.text = destinationInfo.snippet
        
        var typeName: String {
            let removeUnderScores = destinationInfo.type.replacingOccurrences(of: "_", with: " ")
            return removeUnderScores
        }
        typeLabel.text = typeName
        photosCollectionView.reloadData()
    }
    @IBAction func mapsButtonTapped(_ sender: UIButton) {
        guard let destinationInfo = destinationInfo else { return }
        
        DestinationInfoController.shared.fetchMapsURL(destinationInfo: destinationInfo) { (url) in
            if url != nil {
                print("Sent to apple maps from DestintionTBCell")
            } else {
                print("Not able to navigate to apple maps from DestinationTBCell")
            }
        }
    }
    
    
}

extension DestinationTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return destinationInfo?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "destPhotoCell", for: indexPath) as? DestinationPhotosCollectionViewCell,
            let image = destinationInfo?.images[indexPath.row] else { return UICollectionViewCell()}
        
        DestinationInfoController.shared.fetchDestinationImage(imageURL: image.sizes.medium) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    cell.destinationImage.image = image
                }
            }
        }
        
        return cell
        
    }
    
    
}
