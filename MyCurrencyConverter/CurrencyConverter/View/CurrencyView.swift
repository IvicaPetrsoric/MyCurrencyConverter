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
    
    var currencyData: [Currency] = [] {
        didSet{
            fromValueTextField.isUserInteractionEnabled = true
            currencyFromPicker.reloadAllComponents()
        }
    }
    
    weak var delegate: CurrencyViewDelegate?
    private var indicatorView = IndicatorView()
    var totalAmount: Int = 0
    var currency = "AUD"
    let topAmounEntered = 1_000_000_000_00
    
    lazy var fromValueTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.textAlignment = .right
        textField.textColor = .white
        textField.delegate = self
        textField.backgroundColor = .tealColor
        textField.keyboardType = .numberPad
        textField.isUserInteractionEnabled = false
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private let alertLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.text = "To big number entered!"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = .lightRed
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    
    private let startConvertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Convert", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.backgroundColor = .tealColor
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.alpha = 0.5
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(handleConverion), for: .touchUpInside)
        return button
    }()
    
    lazy var currencyFromPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        return picker
    }()
    
    lazy var labelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.buyingLabel, self.sellingLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let buyingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .lightRed
        label.numberOfLines = 0
        return label
    }()
    
    private let sellingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .lightRed
        label.numberOfLines = 0
        return label
    }()
    
    let bankImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "bank").withRenderingMode(.alwaysOriginal))
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        return iv
    }()
    
    @objc private func handleConverion() {
        removeKeyboard()
        
        let fromRowPicker = currencyFromPicker.selectedRow(inComponent: 0)
        let fromCurrency = currencyData[fromRowPicker]
        
        let toRowPicker = currencyFromPicker.selectedRow(inComponent: 1)
        let toCurrency = currencyData[toRowPicker]
        
        if let data =  delegate?.getCurrencyConversion(forValue: totalAmount, fromCurrency: fromCurrency, toCurrency: toCurrency) {
            let sellingAttributedText = NSMutableAttributedString(string: "Selling\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
            sellingAttributedText.append(NSAttributedString(string: String(format: "%.2f", data.currencySellingFromBank),
                                                            attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
            
            let buyingAttributedText = NSMutableAttributedString(string: "Buying\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
            buyingAttributedText.append(NSAttributedString(string: String(format: "%.2f", data.currencyBuyingFromBank),
                                                           attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
            
            buyingLabel.attributedText = sellingAttributedText
            sellingLabel.attributedText = buyingAttributedText
            animateStackView(show: true)
        }
    }
    
    @objc private func removeKeyboard() {
        endEditing(true)
    }
    
    func showAlertMessage() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alertLabel.transform = CGAffineTransform(translationX: 0, y: self.alertLabel.frame.height - 8)
        }) { (completion: Bool) in
            if completion {
                UIView.animate(withDuration: 0.2, delay: 1.5, animations: {
                    self.alertLabel.transform = CGAffineTransform.identity
                })
            }
        }
    }
    
    func handleTextChanged() {
        var toAlpha: CGFloat = 1
        startConvertButton.isUserInteractionEnabled = true
        
        if totalAmount == 0 {
            toAlpha = 0.5
            startConvertButton.isUserInteractionEnabled = false
        }
        
        if startConvertButton.alpha != toAlpha {
            UIView.animate(withDuration: 0.3, animations: {
                self.startConvertButton.alpha = toAlpha
            })
        }
    }
    
    func animateStackView(show: Bool) {
        if show {
            UIView.animate(withDuration: 0.5, animations: {
                self.labelStackView.transform = CGAffineTransform.identity
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.labelStackView.transform = CGAffineTransform(translationX: 0, y: 100)
            })
        }
    }
    
    func removeIndicatorView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.indicatorView.alpha = 0
        }) { (completion: Bool) in
            if completion {
                self.indicatorView.removeFromSuperview()
            }
        }
    }
    
    func updateAmount() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.currencySymbol = currency
        formatter.minimumFractionDigits = 2
        let amount = Double(totalAmount/100) + Double(totalAmount%100)/100
        return formatter.string(from: NSNumber(value: amount))!
    }
    
    override func setupViews() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeKeyboard)))

        addSubview(currencyFromPicker)
        addSubview(alertLabel)
        addSubview(fromValueTextField)
        addSubview(startConvertButton)
        
        addSubview(labelStackView)
        labelStackView.addSubview(bankImageView)
        animateStackView(show: false)

        addSubview(indicatorView)
        
        fromValueTextField.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 44)
       
        alertLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 44)
        
        currencyFromPicker.anchor(top: fromValueTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        startConvertButton.anchor(top: currencyFromPicker.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 40, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 44)
        
        labelStackView.anchor(top: nil, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 88)
       
        bankImageView.anchor(top: labelStackView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        bankImageView.anchorCenter(centerX: centerXAnchor, centerY: nil)

        
        fromValueTextField.setRightPaddingPoints(4)
        fromValueTextField.text = updateAmount()
        
        indicatorView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
}


