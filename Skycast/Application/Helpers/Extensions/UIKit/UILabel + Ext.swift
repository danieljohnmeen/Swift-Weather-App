//
//  UILabel + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 18.12.2022.
//

import UIKit

extension UILabel {
    convenience init(text: String? = nil,
                     textColor: UIColor? = .label,
                     font: UIFont? = .systemFont(ofSize: 17)) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
    }
}
