//
//  CurrencyView.swift
//  MyCurrencyConverter
//
//  Created by Ivica Petrsoric on 04/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

protocol CurrencyViewDelegate: class {
    func getCurrencyConversion(forValue: Int, fromCurrency: Currency, toCurrency: Currency) -> ConverionValues?
}

class CurrencyView: BaseView {
    
    weak var delegate: CurrencyViewDelegate?
    
    lazy var fromValueTextField: UITextField = {
        let textField = UITextField()
        textField.text = ""
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.textAlignment = .right
        textField.delegate = self
        textField.backgroundColor = .green
        textField.keyboardType = .numberPad
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private let alertLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.text = "To big number entered!"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = .red
        return label
    }()
    
    func showAlertMessage() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alertLabel.transform = CGAffineTransform(translationX: 0, y: self.alertLabel.frame.height)
        }) { (completion: Bool) in
            if completion {
                UIView.animate(withDuration: 0.2, delay: 1.5, animations: {
                    self.alertLabel.transform = CGAffineTransform.identity
                })
            }
        }
    }
    
    
    
    
    
    private func handleTextChanged() {
        var toAlpha: CGFloat = 1
        startConvertButton.isUserInteractionEnabled = true
        
        if amt == 0 {
            toAlpha = 0.5
            startConvertButton.isUserInteractionEnabled = false
        }
       
        if startConvertButton.alpha != toAlpha {
            UIView.animate(withDuration: 0.3, animations: {
                self.startConvertButton.alpha = toAlpha
            })
        }
    }
    
    
    private let startConvertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Convert", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.backgroundColor = .lightGreen
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleConverion), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleConverion() {
        removeKeyboard()
        
        let fromRowPicker = currencyFromPicker.selectedRow(inComponent: 0)
        let fromCurrency = currencyData[fromRowPicker]
        
        let toRowPicker = currencyFromPicker.selectedRow(inComponent: 1)
        let toCurrency = currencyData[toRowPicker]
        
        if let data =  delegate?.getCurrencyConversion(forValue: amt, fromCurrency: fromCurrency, toCurrency: toCurrency) {
            let sellingAttributedText = NSMutableAttributedString(string: "Selling\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
            sellingAttributedText.append(NSAttributedString(string: String(format: "%.2f", data.currencySellingFromBank),
                                                            attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
            
            let buyingAttributedText = NSMutableAttributedString(string: "Buying\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
            buyingAttributedText.append(NSAttributedString(string: String(format: "%.2f", data.currencyBuyingFromBank),
                                                           attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
            
            buyingLabel.attributedText = sellingAttributedText
            sellingLabel.attributedText = buyingAttributedText
        }
    }
    
    private func attributedString(forText: String, withBoldFont: Bool) -> NSAttributedString{
        if withBoldFont {
            return NSAttributedString(string: forText, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
        } else {
            return NSAttributedString(string: forText, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
        }
    }
    
    var amt: Int = 0
    
    
    lazy var currencyFromPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        return picker
    }()
    
    private let buyingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .yellow
        label.numberOfLines = 0
        return label
    }()
    
    private let sellingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .yellow
        label.numberOfLines = 0
        return label
    }()
    
    private var currency = "AUD"

    var currencyData: [Currency] = [] {
        didSet{
            fromValueTextField.isUserInteractionEnabled = true
            currencyFromPicker.reloadAllComponents()
        }
    }
        
    @objc private func removeKeyboard() {
        endEditing(true)
    }
    
    
    
    override func setupViews() {
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeKeyboard)))

        addSubview(currencyFromPicker)
        addSubview(alertLabel)
        addSubview(fromValueTextField)
//        addSubview(currencyFromPicker)
        addSubview(startConvertButton)
        
        let stackViewLabels = UIStackView(arrangedSubviews: [buyingLabel, sellingLabel])
        stackViewLabels.axis = .horizontal
        stackViewLabels.distribution = .fillEqually
        
        addSubview(stackViewLabels)
        
        startConvertButton.alpha = 1
        startConvertButton.isUserInteractionEnabled = false
        
        fromValueTextField.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 44)
        alertLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 44)
        
        currencyFromPicker.anchor(top: fromValueTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        startConvertButton.anchor(top: currencyFromPicker.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 40, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 44)
        
        stackViewLabels.anchor(top: nil, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 88)
        
        fromValueTextField.setRightPaddingPoints(4)
        
        fromValueTextField.text = nil
        
        
        fromValueTextField.text = updateAmount()

    }
    
    func updateAmount() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.currencySymbol = currency
        var amount: Double = 0
        if currency == "JPY" {
            amount = Double(amt)
        }else {
            amount = Double(amt/100) + Double(amt%100)/100

        }
        return formatter.string(from: NSNumber(value: amount))!
    }
    

    
    private let topAmounEntered = 1_000_000_000_00
   

    

}

extension CurrencyView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let digit = Int(string) {
            amt = amt * 10 + digit
            
            if amt > topAmounEntered {
                fromValueTextField.text = nil
                amt = 0
                fromValueTextField.text = updateAmount()

                
                showAlertMessage()
                
                
            }else {
                fromValueTextField.text = updateAmount()
            }
            
        }
        
        if string == "" {
            amt = amt / 10
            fromValueTextField.text = updateAmount()
        }
        
        handleTextChanged()
        
        return false
    }

}

extension CurrencyView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(currencyData[row].currencyCode)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0,  currencyData.count > 0{
            currency = currencyData[row].currencyCode
            fromValueTextField.text = updateAmount()
        }
    }
}



