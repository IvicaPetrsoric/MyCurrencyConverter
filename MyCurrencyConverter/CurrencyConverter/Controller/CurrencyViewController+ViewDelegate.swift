//
//  CurrencyViewController+ViewDelegate.swift
//  MyCurrencyConverter
//
//  Created by Ivica Petrsoric on 05/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import Foundation

extension CurrencyViewController: CurrencyViewDelegate {
    
    func getCurrencyConversion(forValue: Int, fromCurrency: Currency, toCurrency: Currency) -> (ConverionValues)? {
        let currentAmount = Double(forValue)
        let fromUnitValueCurrency = Double(fromCurrency.unitValue)
        guard let fromBuyinCurrency = Double(fromCurrency.buyingRate) else { return nil }
        
        let currentAmountToKN = (currentAmount / fromUnitValueCurrency) * fromBuyinCurrency
        
        guard let toBuyingCurrency = Double(toCurrency.buyingRate) else { return nil }
        guard let toSellingCurrency = Double(toCurrency.sellingRate) else { return nil }
        
        let toSellingValue = currentAmountToKN / (toSellingCurrency * 100)
        let toBuyingValue = currentAmountToKN / (toBuyingCurrency * 100)
        
        let conversionValues = ConverionValues(currencySellingFromBank: toSellingValue, currencyBuyingFromBank: toBuyingValue)
        return conversionValues
    }
}
