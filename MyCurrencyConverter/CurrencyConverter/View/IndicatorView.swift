//
//  IndicatorView.swift
//  MyCurrencyConverter
//
//  Created by Ivica Petrsoric on 05/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class IndicatorView: BaseView {
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicator.color = .black
        indicator.startAnimating()
        return indicator
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBlue
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    override func setupViews() {
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        addSubview(backgroundView)
        backgroundView.addSubview(activityIndicator)
        
        backgroundView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        backgroundView.anchorCenter(centerX: centerXAnchor, centerY: centerYAnchor)
        
        activityIndicator.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        activityIndicator.anchorCenter(centerX: centerXAnchor, centerY: centerYAnchor)
    }
    
}
