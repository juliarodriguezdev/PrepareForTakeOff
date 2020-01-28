//
//  IconDetailController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 1/8/20.
//  Copyright © 2020 Julia Rodriguez. All rights reserved.
//

import Foundation

class IconDetailController {
    
    static let shared = IconDetailController()
    
    var iconAttributions : [IconDetail] = []
    
    let roundTrip = IconDetail(iconCredit: "Round trip by Chanut is Industries from the Noun Project")
    let checkMark = IconDetail(iconCredit: "Check Mark by ImageCatalog from the Noun Project")
    let maps = IconDetail(iconCredit: "Map by Symbolon from the Noun Project")
    let world = IconDetail(iconCredit: "World by ✦ Shmidt Sergey ✦ from the Noun Project")
    let checkBox = IconDetail(iconCredit: "Checkbox by Bluetip Design from the Noun Project")
    let location = IconDetail(iconCredit: "Location by Kau Xuan Xi from the Noun Project")
    let tickets = IconDetail(iconCredit: "Tickets by b farias from the Noun Project")
    let cloud = IconDetail(iconCredit: "Cloud by Daria Moskvina from the Noun Project")
    let moneyExhcange = IconDetail(iconCredit: "Money exchange by Nhor from the Noun Project")
    
    func loadIconDetails() {
        iconAttributions = [roundTrip, checkMark, checkBox, maps, world, location, tickets, cloud, moneyExhcange]
    }
}
