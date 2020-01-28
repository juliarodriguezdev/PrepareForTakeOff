//
//  CuurencyNameHelper.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/19/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation

enum CurrencyNameHelper {
    
    static var typeName = [
    
        "AED": "UAE Dirham",
        "AFN": "Afghan Afghani",
        "XCD": "East Caribbean Dollar",
        "ALL": "Albanian Lek",
        "AMD": "Armenian Dram",
        "AOA": "Angolan Kwanza",
        "ARS": "Argentine Peso",
        "USD": "US Dollar",
        "AUD": "Australian Dollar",
        "AWG": "Aruban Florin",
        "AZN": "Azerbaijan Manat",
        
        "BAM": "Convertible Mark",
        "BBD": "Barbados Dollar",
        "BDT": "Bangladeshi Taka",
        "XOF": "CFA Franc BCEAO",
        "BGN": "Bulgarian Lev",
        "BHD": "Bahraini Dinar",
        "BIF": "Burundi Franc",
        "BMD": "Bermudian Dollar",
        "BND": "Brunei Dollar",
        "BOB": "Boliviano",
        "BRL": "Brazilian Real",
        "BSD": "Bahamian Dollar",
        "BTN": "Bhutanese Ngultrum",
        "NOK": "Norwegian Krone",
        "BWP": "Pula",
        "BYR": "Belarusian Ruble",
        "BZD": "Belize Dollar",
        
        "CAD": "Canadian Dollar",
        "CDF": "Franc Congolais",
        "XAF": "CFA Franc BEAC",
        "CHF": "Swiss Franc",
        "NZD": "New Zealand Dollar",
        "CLP": "Chilean Peso",
        "CNY": "Renminbi (Yuan)",
        "COP": "Colombian Peso",
        "CRC": "Costa Rican Colón",
        "CUP": "Cuban Peso",
        "CVE": "Cape Verde Escudo",
        "ANG": "Netherlands Antilles Guilder",
        "CZK": "Czech Koruna",
        
        "DJF": "Djibouti Franc",
        "DKK": "Danish Kroner",
        "DOP": "Dominican Peso",
        "DZD": "Algerian Dinar",
        "EGP": "Egyptian Pound",
        "EUR": "Euro",
        "MAD": "Moroccan Dirham",
        "ERN": "Nakfa",
        
        "ETB": "Ethiopian Birr",
        
        "FJD": "Fiji Dollar",
        "FKP": "Falkland Islands pound",
        
        "GBP": "Pound Sterling",
        
        "GEL": "Lari",
        "GHS": "Ghanaian Cedi",
        "GIP": "Gibraltar Pound",
        "GMD": "Dalasi",
        "GNF": "Guinea Franc",
        "GTQ": "Quetzal",
        "GYD": "Guyana Dollar",
        
        "HKD": "Hong Kong Dollar",
        "HNL": "Lempira",
        "HRK": "Croatian Kuna",
        "HTG": "Haitian Gourde",
        "HUF": "Forint",
        
        "IDR": "Rupiah",
        "ILS": "New Israeli Sheqel",
        "INR": "Indian Rupee",
        "IQD": "Iraqi Dinar",
        "IRR": "Iranian Rial",
        "ISK": "Iceland Krona",
        
        "JMD": "Jamaican Dollar",
        "JOD": "Jordanian Dinar",
        "JPY": "Yen",
        "KES": "Kenyan Shilling",
        "KGS": "Som",
        "KHR": "Cambodian Riel",
        "KMF": "Comoro Franc",
        "KPW": "North Korean Won",
        "KRW": "Won",
        "KWD": "Kuwaiti Dinar",
        "KYD": "Cayman Islands Dollar",
        "KZT": "Tenge",
        
        "LAK": "Kip",
        "LBP": "Lebanese Pound",
        "LKR": "Lebanese Pound",
        "LRD": "Liberian Dollar",
        "LSL": "Loti",
        "LTL": "Lithuanian Litas",
        "LYD": "Lybian Dinar",
        "MDL": "Moldovan Leu",
        "MGA": "Madagascar Ariary",
        "MKD": "Macedonian Denar",
        "MMK": "Burmese Kyat",
        "MNT": "Mongolia Tughrik",
        "MOP": "Macanese Pataca",
        "MRO": "Ouguiya",
        "MUR": "Mauritius Rupee",
        "MVR": "Rufiyaa",
        "MWK": "Kwacha",
        "MXN": "Mexican Peso",
        "MYR": "Malaysian Ringgit",
        "MZN": "Mozambican Metical",
        
        "NAD": "Namibia Dollar",
        "XPF": "CFP Franc",
        "NGN": "Nigerian Naira",
        "NIO": "Nicaraguan Córdoba",
        "NPR": "Nepalese Rupee",
        
        "OMR": "Omani Rial",
        
        "PAB": "Panamanian Balboa",
        "PEN": "Peruvian (Nuevo) Sol",
        "PGK": "Papua New Guinean Kina",
        "PHP": "Philippine Peso",
        "PKR": "Pakistan Rupee",
        "PLN": "Polish Zloty",
        "PYG": "Paraguayan Guarani",
        
        "QAR": "Qatari Rial",
        
        "RON": "Romanian Leu",
        "RSD": "Serbian Dinar",
        "RUB": "Russian Ruble",
        "RWF": "Rwanda Franc",
        
        "SAR": "Saudi Riyal",
        "SBD": "Solomon Islands Dollar",
        "SCR": "Seychelles Rupee",
        "SDG": "Sudanese Pound",
        "SEK": "Swedish Krona",
        "SGD": "Singapore Dollar",
        "SHP": "Saint Helena Pound",
        "SLL": "Leone",
        "SOS": "Somali Shilling",
        "SRD": "Surinamese Dollar",
        "SSP": "South Sudanese pound",
        "STD": "Dobra",
        "SYP": "Syrian Pound",
        "SZL": "Lilangeni",
        
        "THB": "Thai Baht",
        "TJS": "Somoni",
        "TMT": "Turkmenistani Manat",
        "TND": "Tunisian Dinar",
        "TOP": "Paʻanga",
        "TRY": "Turkish Lira ",
        "TTD": "Trinidad and Tobago Dollar",
        "TWD": "New Taiwan Dollar",
        "TZS": "Tanzanian Shilling",
        
        "UAH": "Ukrainian Hryvnia",
        "UGX": "Uganda Shilling",
        "UYU": "Uruguayan Peso",
        "UZS": "Uzbekistan Sum",
        
        "VEF": "Venezuelan Bolívar",
        "VND": "Vietnamese Dong",
        "VUV": "Vanuatu Vatu",
        
        "WST": "Tala",

        "YER": "Yemeni Rial",

        "ZAR": "South African Rand",
        "ZMK": "South African Rand",
        "ZWL": "Zimbabwean Dollar"
    ]
    
    static func fetchCurrencyName(currencyCode: String) -> String {
        if let currencyName = CurrencyNameHelper.typeName[currencyCode] {
            return currencyName
        } else {
            return currencyCode
        }
    }
}
