//
//  ViewController.swift
//  MyCurrencyConverter
//
//  Created by Ivica Petrsoric on 04/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {
    
    private var currencyView = CurrencyView()
    private var service = Server()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Currency Converter"
        
        currencyView.delegate = self
        
        setupViews()
        fetchData()        
    }
    
    private func setupViews() {
        view.addSubview(currencyView)
        
        currencyView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func fetchData() {
        service.fetchCurrencyData { (compleated, data) in
            if compleated {
                guard let data = data else { return }
                self.currencyView.currencyData = data 
            } else {
                self.showAllert(message: AlertMessage.missingWeb.rawValue)
            }
        }
    }
    
    


}

extension CurrencyViewController: CurrencyViewDelegate {
    
    func getCurrencyConversion(forValue: Int, fromCurrency: Currency, toCurrency: Currency) -> ConverionValues? {
        let currentAmount = Double(forValue / 100)
        let fromUnitValueCurrency = Double(fromCurrency.unitValue)
        guard let fromBuyinCurrency = Double(fromCurrency.buyingRate) else { return nil}
        
        let currentAmountToKN = (currentAmount / fromUnitValueCurrency) * fromBuyinCurrency
        
        guard let toBuyingCurrency = Double(toCurrency.buyingRate) else { return nil}
        guard let toSellingCurrency = Double(toCurrency.sellingRate) else { return nil}
        
        let toSellingValue = currentAmountToKN / toBuyingCurrency
        let toBuyingValue = currentAmountToKN / toSellingCurrency
        
        let conversionValues = ConverionValues(currencySellingFromBank: toSellingValue, currencyBuyingFromBank: toBuyingValue)
        return conversionValues
        
//        print(pickerToRow)
//
//        print("Text: ", (fromValueTextField.text))
//        print("Amount1: ", amt)
//
//        let currentAmount = amt / 100
//
//        print("Amount2: ", currentAmount)
//
//        let currentBuyyingFromBank = currencyData[fromRowPicker].buyingRate
//
//        let currentlyToKn = (Double(currentAmount) / Double(currencyData[fromRowPicker].unitValue)) * Double(currentBuyyingFromBank)!
//        print("Kn: ", currentlyToKn)
//
//        let sellingFromBankInOtherCurrenc = currentlyToKn / Double(currencyData[toRowPicker].sellingRate)!
//        let buyyingFromBank = currentlyToKn / Double(currencyData[toRowPicker].buyingRate)!
//
//        print("Prodajni: ", sellingFromBankInOtherCurrenc)
//        print("Kupovni: ", buyyingFromBank)
        
//        return ConverionValues(currencySellingFromBank: 10, currencyBuyingFromBank: 10)
    }
}

