//
//  CustomClearButtonPositionTextField.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/12.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class CustomClearButtonPositionTextField: UITextField {
    var rightInset: CGFloat = 10
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originFrame = super.clearButtonRect(forBounds: bounds)
        return CGRect(x: originFrame.minX - rightInset, y: originFrame.minY, width: originFrame.width, height: originFrame.height)
    }
}
