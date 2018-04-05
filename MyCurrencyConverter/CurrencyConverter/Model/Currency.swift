//
//  CurrencyData.swift
//  MyCurrencyConverter
//
//  Created by Ivica Petrsoric on 04/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

struct Currency {
    
    enum Attributes: String {
        case buying_rate
        case currency_code
        case selling_rate
        case unit_value
        case median_rate
    }
    
    var buyingRate: String
    var currencyCode: String
    var sellingRate: String
    var unitValue: Int
    var medianRate: String
    
    init(dictionary: [String: AnyObject]) {
        self.buyingRate = dictionary[Attributes.buying_rate.rawValue] as? String ?? ""
        self.currencyCode = dictionary[Attributes.currency_code.rawValue] as? String ?? ""
        self.sellingRate = dictionary[Attributes.selling_rate.rawValue] as? String ?? ""
        self.unitValue = dictionary[Attributes.unit_value.rawValue] as? Int ?? 0
        self.medianRate = dictionary[Attributes.median_rate.rawValue] as? String ?? ""
        
    }

}

