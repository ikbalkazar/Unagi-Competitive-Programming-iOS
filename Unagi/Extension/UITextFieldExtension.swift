//
//  UITextFieldExtension.swift
//  Unagi
//
//  Created by Harun Gunaydin on 5/1/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import Foundation
import UIKit

extension UITextField
{
    func setBottomBorder(color: UIColor )
    {
        self.borderStyle = UITextBorderStyle.None;
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}