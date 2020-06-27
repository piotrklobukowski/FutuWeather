//
//  AlertView.swift
//  ThingsForFutuWeather
//
//  Created by Piotr Kłobukowski on 29/05/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    override func layoutSubviews() {
        layer.cornerRadius = 19
        backgroundColor = GradientColorMaker.colorWithGradient(frame: bounds, colors: K.errorColorGradient, direction: GradientColorMaker.GradientDirection.Down)
        self.addSubview(message)
        
        message.leadingAnchor.constraint(equalTo: leadingAnchor, constant: (0.03 * bounds.width)).isActive = true
        message.trailingAnchor.constraint(equalTo: trailingAnchor, constant: (-0.03 * bounds.width)).isActive = true
        message.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        message.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        heightAnchor.constraint(equalTo: message.heightAnchor, multiplier: 1.5).isActive = true
    }
    
    var message: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        lb.textColor = UIColor.white
        lb.numberOfLines = 0
        lb.lineBreakMode = .byWordWrapping
        lb.textAlignment = .left
        return lb
    }()
}
