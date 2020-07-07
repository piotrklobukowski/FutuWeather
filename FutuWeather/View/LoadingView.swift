//
//  LoadingView.swift
//  ThingsForFutuWeather
//
//  Created by Piotr Kłobukowski on 29/05/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let text: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.text = "Loading"
        txt.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        txt.textColor = UIColor.white
        txt.textAlignment = .center
        return txt
    }()
 
    private func setupStack() {
        self.addSubview(stack)
        stack.addArrangedSubviews(views: [text, dots])
        
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -30).isActive = true
    }
    
    let dots = AnimatedDots()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = 15
        return stack
    }()
}
