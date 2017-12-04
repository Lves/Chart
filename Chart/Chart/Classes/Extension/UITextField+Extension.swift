//
//  UITextField+Extension.swift
//  Chart
//
//  Created by lixingle on 2017/12/4.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

extension UITextField {
    @IBInspectable public var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
    @IBInspectable public var placeHolderFont: UIFont? {
        get {
            return self.placeHolderFont
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.font: newValue!])
        }
    }
}
