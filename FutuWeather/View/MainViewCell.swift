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
        addSubview(container)
        
        NSLayoutConstraint.activate([container.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     container.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
                                     container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
                                     container.topAnchor.constraint(equalTo: topAnchor, constant: 15),
                                     container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)])
        
        container.addSubview(stack)
        
        NSLayoutConstraint.activate([stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                                     stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                                     stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 25),
                                     stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -25),
                                     stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
                                     stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14)])
        
        NSLayoutConstraint.activate([icon.heightAnchor.constraint(equalTo: stack.heightAnchor),
                                     icon.widthAnchor.constraint(equalTo: icon.heightAnchor)])
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let container: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.2
        return view
    }()
    
    lazy var stack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [dateStack, tempLabel, icon])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    lazy var dateStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [dayLabel, monthLabel])
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
