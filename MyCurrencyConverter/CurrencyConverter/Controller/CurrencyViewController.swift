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
        
        view.backgroundColor = .darkBlue
        
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
            self.currencyView.removeIndicatorView()
            
            if compleated {
                guard let data = data else { return }
                self.currencyView.currencyData = data
            } else {
                self.showAllert(message: AlertMessage.missingWeb.rawValue)
            }
        }
    }

}



