//
//  PopupTextField.swift
//  ThingsForFutuWeather
//
//  Created by Piotr Kłobukowski on 29/05/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class PopupTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        layer.borderColor = Customization.mainColor.cgColor
        layer.cornerRadius = Customization.cornerRadius
        layer.borderWidth = Customization.borderWidth
        textColor = Customization.mainColor
        adjustsFontSizeToFitWidth = true
        minimumFontSize = Customization.minFontSize
        tintColor = Customization.mainColor
        let f = font?.pointSize ?? 20
        attributedPlaceholder = NSAttributedString(string: "placeholder text",
                                                   attributes: [NSAttributedString.Key.foregroundColor: Customization.mainColor,
                     NSAttributedString.Key.font : UIFont.systemFont(ofSize: f, weight: .regular)])
    }
    
    private enum Customization {
        static let cornerRadius: CGFloat = 10
        static let borderWidth: CGFloat = 2
        static let mainColor: UIColor = .white
        static let minFontSize: CGFloat = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
}
