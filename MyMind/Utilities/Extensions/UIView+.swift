//
//  UIView+.swift
//  MyMind
//
//  Created by Shih Allan on 2021/11/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

final class BindableGestureRecognizer: UITapGestureRecognizer {
    private var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        action()
    }
}

public extension UIView {
    /// A discrete gesture recognizer that interprets single or multiple taps.
    /// - Parameters:
    ///   - tapNumber: The number of taps necessary for gesture recognition.
    ///   - closure: A selector that identifies the method implemented by the target to handle the gesture recognized by the receiver. The action selector must conform to the signature described in the class overview. NULL is not a valid value.
    func addTapGesture(tapNumber: Int = 1, _ closure: (() -> Void)?) {
        guard let closure = closure else { return }

        let tap = BindableGestureRecognizer(action: closure)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)

        isUserInteractionEnabled = true
    }
}
