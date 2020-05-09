//
//  UITextField + Extension.swift
//  Weather
//
//  Created by Daniel Gomes on 27/03/20.
//  Copyright © 2020 Daniel Gomes. All rights reserved.
//

import UIKit

extension UITextField {
    func placeholderColor(color: UIColor) {
        let attributeString = [
            NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.6),
            NSAttributedString.Key.font: self.font!
            ] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributeString)
    }
}
