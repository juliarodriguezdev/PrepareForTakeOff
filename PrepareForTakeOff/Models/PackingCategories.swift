//
//  PackingCategories.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/21/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation

class PackingCategories {
    
    static let shared = PackingCategories()
    // an init
    init() {
        retrieveCategoryKeys()
    }
    
    var categoryKeys = [String]()
    
    var categories = [
        "Toiletries": ["Shampoo", "Conditioner", "Comb", "Soap", "Facial Cleanser", "Loofa", "Wash cloth", "Body Lotion", "Face Lotion", "Q-tips", "Deodorant", "Sunscreen", "Bug Repellant", "Sunglases","Shaving Cream", "Razor", "Tooth paste", "Tooth brush", "Floss", "Hair spray", "Hair mousse", "Hair gel", "Phone Charger", "Camera"],
        
        "Electronics": ["Phone", "Phone Charger", "Portable Charger", "Headphones", "Ear Pods", "Converter", "Adapter", "Extension Cord", "Tablet", "Tablet Charger"],
        
        "Medicine": ["Pain Reliever Medicine", "Headache Medicine", "Nausea Medicine", "Upset Stomach Medicine", "Allergy Medicine"],
        
        "Swimming": ["Swimsuit", "Swim Trunks", "Towel", "Cover Up", "Sandals"],
        
        "Women's Accessories": ["Hair tie, Purse", "Bobby pins", "Hair Clips"],
        
        "Hiking": ["Hiking Shoes", "Camel bag", "Back Pack", "Sticks"],
        
        "Skiing": ["Skiis", "Boots", "Face Mask", "Gloves", "Long Johns", "Jacket", "Ski Goggles"]
        
    ]
    
    func retrieveCategoryKeys() {
        for (key, _) in categories {
            categoryKeys.append(key)
        }
    }
}
