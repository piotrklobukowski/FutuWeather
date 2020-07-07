//
//  AlertView.swift
//  ThingsForFutuWeather
//
//  Created by Piotr Kłobukowski on 29/05/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 19
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = GradientColorMaker.colorWithGradient(frame: bounds, colors: Constants.errorColorGradient, direction: GradientColorMaker.GradientDirection.Down)
    }
    
    func prepareView() {
        addSubview(message)
        NSLayoutConstraint.activate([message.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                                     message.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                                     message.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     message.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     heightAnchor.constraint(equalTo: message.heightAnchor, multiplier: 1.5)])
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
