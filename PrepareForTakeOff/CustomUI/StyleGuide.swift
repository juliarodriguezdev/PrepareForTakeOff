//
//  StyleGuide.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/21/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit
    
extension UIView {
        func addCornerRadius(_ radius: CGFloat = 10) {
            self.layer.cornerRadius = radius
        }
        
    func addBorder(width: CGFloat = 1, color: UIColor = UIColor.darkGray) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width 
    }
}

struct FontNames {
    static let fingerPaintRegular = "FingerPaint-Regular"
    static let lingWaiSCMedium = "LingWaiSC-Medium"
    static let nunitoLight = "Nunito-Light"
    static let nunitoSemiBold = "Nunito-SemiBold"
}

extension UIColor {
    static let travelBackground = UIColor(named: "mustardYellow")
    static let customGray = UIColor(named: "buttonGray")
    static let hintYellow = UIColor(named: "hintYellow")
    static let mint = UIColor(named: "mint")
}
