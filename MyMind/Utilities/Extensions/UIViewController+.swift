//
//  UIViewController+.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/23.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    func addTapToResignKeyboardGesture(in view: UIView? = nil) {
        var viewToAddGesture: UIView = self.view
        if view != nil {
            viewToAddGesture = view!
        }
        let tapGesture = UITapGestureRecognizer(target: viewToAddGesture, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        viewToAddGesture.addGestureRecognizer(tapGesture)
    }
}

private var indicator: Void?

extension UIViewController {
    var activityIndicator: NVActivityIndicatorView? {
        get {
            objc_getAssociatedObject(self, &indicator) as? NVActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &indicator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func startAnimatingActivityIndicator() {
        if activityIndicator == nil {
            activityIndicator = NVActivityIndicatorView(
                frame: .zero,
                type: .ballSpinFadeLoader,
                color: UIColor(hex: "043458")
            )
        }
        activityIndicator?.frame = CGRect(
            origin: .zero,
            size: CGSize(width: 50, height: 50)
        )
        activityIndicator?.center = view.center
        view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
    }

    func stopAnimatinActivityIndicator() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
    }
}
