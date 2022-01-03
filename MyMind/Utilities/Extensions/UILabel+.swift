//
//  UILabel+.swift
//  MyMind
//
//  Created by Shih Allan on 2022/1/3.
//  Copyright © 2022 United Digital Intelligence. All rights reserved.
//

import UIKit

extension UILabel {
    func getFontSize(_ font: UIFont) -> CGRect? {
        var rect: CGRect = frame
        //Calculate as per label font
        rect.size = (text?.size(withAttributes: [NSAttributedString.Key.font: font])) ?? CGSize(width: 0, height: 0)
        return rect
    }
}
