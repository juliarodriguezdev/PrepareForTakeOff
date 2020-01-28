//
//  GrayButton.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 12/10/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class GrayButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func updateFont(to fontName: String) {
        //guard let size = self.titleLabel?.font.pointSize else { return }
        self.titleLabel?.font = UIFont(name: fontName, size: 24)
    }
    func setUpUI() {
        self.backgroundColor = UIColor.customGray
        self.setTitleColor(.white, for: .normal)
        updateFont(to: FontNames.fingerPaintRegular)
        self.addCornerRadius(14)
    }
}
