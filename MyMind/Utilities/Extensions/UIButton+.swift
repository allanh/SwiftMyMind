//
//  UIButton+.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

private var buttonTouchEdgeInsets: Void?

extension UIButton {

    var touchEdgeInsets: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &buttonTouchEdgeInsets) as? UIEdgeInsets
        }
        set {
            objc_setAssociatedObject(self, &buttonTouchEdgeInsets, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var frame = self.bounds

        if let touchEdgeInsets = self.touchEdgeInsets {
            frame = frame.inset(by: touchEdgeInsets)
        }

        return frame.contains(point)
    }
}
