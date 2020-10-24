//
//  UIButton+Extension.swift
//  FloodWarning
//
//  Created by Doyinsola Osanyintolu on 10/20/20.
//

import Foundation
import UIKit


extension UIButton {
   static func buttonForRightAccessoryView() -> UIButton {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 18, height: 22)
        button.setImage(UIImage(named: "trash"), for: .normal)
        return button
    }
}
