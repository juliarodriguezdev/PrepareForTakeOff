//
//  CurrencyExchangeCodes.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/7/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class CurrencyExchangeCodes {
    
    // USD_MXN
    var usersCurrencyCode: String
    var destinationCurrencyCode: String
    //var apiSearchQuery: String
    
    init(usersCurrencyCode: String = Locale.current.currencyCode ?? "USD", destinationCurrencyCode: String) {
        self.usersCurrencyCode = usersCurrencyCode
        self.destinationCurrencyCode = destinationCurrencyCode
        //self.apiSearchQuery = apiSearchQuery
    }
}
