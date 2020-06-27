//
//  LoadingView.swift
//  ThingsForFutuWeather
//
//  Created by Piotr Kłobukowski on 29/05/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    let text: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.text = "Loading"
        txt.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        txt.textColor = UIColor.white
        txt.textAlignment = .center
        
        return txt
    }()
    
    override func layoutSubviews() {
        
        self.addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: (0.25 * self.frame.width)).isActive = true
    }
    
    let dots = AnimatedDots()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [text, dots])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = 15
        
        return stack
    }()
}
