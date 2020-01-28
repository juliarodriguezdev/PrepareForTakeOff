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
        "Travel Documents": ["Photo ID", "Driver's License", "Passport", "Visa", "Global Entry Card", "Boarding Pass", "Confirmation Receipts", "Emergency Docs", "Emergency Contacts", "Important Addresses", "Tickets", "Itinerary", "Reservations"],
        
        "Funds": ["Wallet", "Money Clip", "Money Belt", "RFID Blocking Wallet", "Credit Cards", "Debit Card", "Cash"],
        
        "Travel Comfort": ["Neck Pillow", "Eye Mask", "Ear plugs", "Book", "Magazine", "Snacks", "Gum", "Spare Clothes"],
        
        "Toiletries": ["Shampoo", "Conditioner", "Comb", "Soap", "Facial Cleanser", "Loofa", "Wash cloth", "Body Wash", "Soap", "Body Lotion", "Face Lotion", "Lip Balm", "Q-tips", "Deodorant", "Sunscreen", "Bug Repellant", "Shaving Cream", "Razor", "Tooth paste", "Tooth brush", "Floss", "Tissue", "Cotton Balls", "Rounds", "Wet Wipes", "Nail Clippers", "Hand Sanitizer", "Laundry Bag", "Water Bottle"],
        
        "Eyes": [ "Contacts","Contact Solutions", "Eye Drops", "Contact Case", "Glasses", "Glasses Case", "Glasses Repair", "Lens Cleaner"],
        
        "Hair": ["Comb", "Brush","Hair spray", "Hair mousse", "Hair gel", "Hair cream", "Hair Paste"],
        
        "Hair Tools": ["Blow Dryer", "Straightener", "Curling Iron", "Hair Trimmer"],
        
        "Clothing": ["Casual Top", "Dress Top", "Athletic Top", "T-Shirt", "Tank Top", "Long Sleeved Shirt", "Jeans", "Casual Pants", "Dress Pants", "Slacks", "Sweats", "Joggers", "Sweaters", "Fleece Jacket", "Cardigans", "Outerwear", "Rain Jacket", "Activewear", "Swimwear", "Pajamas", "Loungewear", "Underwear", "Socks", "Gloves", "Beanie"],
        
        "Shoes": ["Tennis Shoes", "Dress Shoes", "Sandals", "Boots", "Water shoes", "Cycling shoes", "Hiking boots", "Slippers"],
        
        "Masculine Items": ["Suits", "Beard Scissors", "Beard Balm", "Cologne", "Ties", "Tie Clips", "Pocket Squares", "Trunks", "Swim Shorts", "Speedo", "Boxers", "Boxer Briefs", "Briefs", "Loafers", "Shaving Soap"],
        
        "Feminine Items" : ["Tweezers", "Makeup", "Makeup Remover", "Nail Polish", "Perfume", "Tampons", "Pads", "Hair Ties", "Bobby Pins", "Hair Clips","Purses", "Blouses", "Dresses", "Leggings", "Yoga Pants", "Skirts", "Blazers", "Rompers","Swim Suit", "Cover-Up", "Cashmere Wrap", "Panties", "Thongs", "Bras", "Sports Bras", "Tights", "Hosiery", "Heels", "Flats"],
        
        
        "Medicine": ["Prescriptions", "Pain Reliever Medicine", "Headache Medicine", "Nausea Medicine", "Upset Stomach Medicine", "Allergy Medicine", "Antihistamines", "Motion Sickness Medicine", "Sleep Aid", "Melatonin", "Cold/Flu Medicine", "Aspirin", "Advil", "Aleve"],
        
        "First Aid": ["Band-Aids", "Antibiotic ointment", "Antibacterial Ointment", "Gauzes", "Rubbing alcohol", "Hydrogen peroxide", "Disenfecting solution", "Insect repellant", "Vitamins"],
        
        "Electronics": ["Phone", "Phone Charger", "Portable Charger", "Headphones", "Ear Pods", "Converter", "Adapter", "Extension Cord", "Tablet", "iPad", "Tablet Charger", "Camera", "Laptop", "Laptop Charger", "Drone", "Electronic Games", "External Charger"],
        
        "Accessories": ["Sunglasses", "Watch", "Apple Watch", "FitBit", "Jewelry", "Belts", "Scarf", "Bandana", "Hat", "Viser", "Umbrella", "Duffel Bag", "Mirror", "Cable Lock", "Lock", "Headlamp", "Sewing Kit"],
        
        "Swimming": ["Swimsuit", "Swim Trunks", "Towel", "Cover Up", "Sandals", "Goggles", "Flotation Device", "Wet Bag", "Robe", "Swim Cap", "Flip Flops"],
        
        "Hiking": ["Hiking Shoes", "Hiking Socks", "Camel bag", "Back Pack", "Trekking Poles", "Lights", "Headlamp", "Hiking Snacks"],
        
        "Skiing / Snowboarding": ["Skiis", "Snowboard", "Ski Poles", "Helmets", "Snow Boots", "Face Mask", "Gloves", "Mittens", "Long Johns", "Jacket", "Ski Goggles", "Ski Pants", "Overalls", "Thermal Tops", "Thermal Pants", "Neck Warmer", "Wool Socks", "Beanie", "Snow Hat", "Wrist Guards", "Knee Pads", "Necker Gaiter", "Balaclava"],
        
        "Amusements": ["Flash Cards", "Playing Cards", "Books", "Games", "Coloring/Activity Books", "Toys", "Notebook", "Washable Colors"]
        
    ]
    
    func retrieveCategoryKeys() {
        for (key, _) in categories {
            categoryKeys.append(key)
        }
    }
}
