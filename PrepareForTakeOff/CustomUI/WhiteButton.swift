//
//  WhiteButton.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 12/20/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class WhiteButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func updateFont(to fontName: String) {
        guard let size = self.titleLabel?.font.pointSize else { return }
        self.titleLabel?.font = UIFont(name: fontName, size: size)
    }
    
    func setUpUI() {
        self.backgroundColor = .white
        self.setTitleColor(.black, for: .normal)
        updateFont(to: FontNames.fingerPaintRegular)
        self.addCornerRadius(14)
    }
}
