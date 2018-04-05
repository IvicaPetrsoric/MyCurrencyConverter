//
//  CurrencyView+UITextFieldDelegate.swift
//  MyCurrencyConverter
//
//  Created by Ivica Petrsoric on 05/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

extension CurrencyView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let digit = Int(string) {
            totalAmount = totalAmount * 10 + digit
            
            if totalAmount > topAmounEntered {
                totalAmount = 0
                fromValueTextField.text = nil
                showAlertMessage()
            }
            
            fromValueTextField.text = updateAmount()
        }
        
        if string == "" {
            animateStackView(show: false)
            totalAmount = totalAmount / 10
            fromValueTextField.text = updateAmount()
        }
        
        handleTextChanged()
        
        return false
    }
    
}
