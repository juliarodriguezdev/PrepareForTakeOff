//
//  PointOfInterestTableViewCell.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/15/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class PointOfInterestTableViewCell: UITableViewCell {
    
    var pointOfInterest: PointOfInterest?
    
    @IBOutlet weak var nameLabel: UILabel!
        
    @IBOutlet weak var locationLabel: UILabel!
    
   // @IBOutlet weak var scoreLabel: UILabel!
        
    @IBOutlet weak var snippetLabel: UILabel!
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
    }


    func updateViews() {
        guard let pointOfInterest = pointOfInterest else { return }
        nameLabel.text = pointOfInterest.name
        print(pointOfInterest.name)
        //scoreLabel.text = "Score: " + String(format: "%.2f", pointOfInterest.score)

        snippetLabel.text = pointOfInterest.snippet
        
        var locationName: String {
            let name = pointOfInterest.locationID
            let removeUnderScores = name.replacingOccurrences(of: "_", with: " ")
            if removeUnderScores.contains("2C") == true {
                let removeCaps = removeUnderScores.replacingOccurrences(of: "2C", with: ",")
                return removeCaps
            } else {
                return removeUnderScores
            }
        }
        locationLabel.text = "\(locationName) | Score: " + String(format: "%.2f", pointOfInterest.score)
        photosCollectionView.reloadData()
    }
    
    @IBAction func mapButtonTapped(_ sender: UIButton) {
        // send coordinates to apple maps
        guard let pointOfInterest = pointOfInterest else { return }
          
        PointOfInterestController.shared.fetchMapsURL(pointOfInterest: pointOfInterest) { (url) in
            if url != nil {
                print("Sent to apple maps from POITBCell")
            } else {
                print("Not able to navigate to apple maps from POITBCell")
            }
        }
    }
}
extension PointOfInterestTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pointOfInterest?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosCell", for: indexPath) as? PointOfInterestPhotosCollectionViewCell,
            let image = pointOfInterest?.images[indexPath.row]
            else { return UICollectionViewCell()}
        
        PointOfInterestController.shared.fetchDestinationImage(imageURL: image.sizes.medium) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    cell.image.image = image
                }
            }
        }
        
        return cell
        
    }
    
    
}
