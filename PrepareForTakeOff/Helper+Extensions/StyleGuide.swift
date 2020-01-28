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

