//
//  MainViewCell.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 08/06/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class MainViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        self.selectionStyle = .none
        setupContainer()
        setupStack()
        setupIcon()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContainer() {
        contentView.addSubview(container)
        NSLayoutConstraint.activate([container.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     container.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Customization.containerInsets),
                                     container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Customization.containerInsets)),
                                     container.topAnchor.constraint(equalTo: topAnchor, constant: Customization.containerInsets),
                                     container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(Customization.containerInsets))])
    }
    
    private func setupStack() {
        container.addSubview(stack)
        dateStack.addArrangedSubviews(views: [dayLabel, monthLabel])
        stack.addArrangedSubviews(views: [dateStack, tempLabel, icon])
        NSLayoutConstraint.activate([stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                                     stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                                     stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 25),
                                     stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -25),
                                     stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
                                     stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14)])
    }
    
    private enum Customization {
        static let containerInsets: CGFloat = 15
        static let cornerRadius: CGFloat = 20
        static let shadowOffset = CGSize(width: 10, height: 10)
        static let shadowRadius: CGFloat = 8
        static let shadowOpacity: Float = 0.3
    }
    
    private func setupIcon() {
        NSLayoutConstraint.activate([icon.heightAnchor.constraint(equalTo: stack.heightAnchor),
        icon.widthAnchor.constraint(equalTo: icon.heightAnchor)])
    }
    
    let container: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Customization.cornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = Customization.shadowOffset
        view.layer.shadowRadius = Customization.shadowRadius
        view.layer.shadowOpacity = Customization.shadowOpacity
        return view
    }()
    
    var stack: UIStackView = {
       let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    var dateStack: UIStackView = {
       let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .regular)
        label.textColor = UIColor.white
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 23, weight: .regular)
        label.textColor = UIColor.white
        
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 60, weight: .regular)
        label.textColor = UIColor.white
        return label
    }()
    
    let icon: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
}
