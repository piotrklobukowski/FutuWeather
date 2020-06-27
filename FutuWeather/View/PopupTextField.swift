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
        self.backgroundColor = UIColor.clear
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.textColor = UIColor.white
        self.adjustsFontSizeToFitWidth = true
        self.minimumFontSize = 15
        self.tintColor = UIColor.white
        self.attributedPlaceholder = NSAttributedString(string: "placeholder text",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                     NSAttributedString.Key.font : UIFont.systemFont(ofSize: self.font!.pointSize, weight: .regular)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
