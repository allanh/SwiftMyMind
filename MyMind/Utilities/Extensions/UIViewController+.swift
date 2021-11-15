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
//        tapGesture.cancelsTouchesInView = false
        viewToAddGesture.addGestureRecognizer(tapGesture)
    }

    func addCustomBackNavigationItem(image: String = "back_arrow", action: (() -> Void)? = nil) {
        let button = UIButton()
        button.setImage(UIImage(named: image), for: .normal)

        button.addAction { [weak self] in
            if let action = action {
                action()
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        let barButton = UIBarButtonItem(customView: button)
        barButton.style = .plain
        navigationItem.setLeftBarButton(barButton, animated: true)
    }
    
    func setTabBarBackgroundColor(_ color: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.pingFangTCSemibold(ofSize: 18)
        ]
        appearance.backgroundColor = color
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
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

        view.addSubview(activityIndicator!)

        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator!.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator!.heightAnchor.constraint(equalToConstant: 50)
        ])

        activityIndicator?.startAnimating()
    }

    func stopAnimatinActivityIndicator() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
    }
}
