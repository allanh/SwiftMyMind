//
//  ToastView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/23.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class ToastView: NiblessView {

    enum Position {
        case top, center, bottom
    }
    private let imageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let label: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.pingFangTCRegular(ofSize: 14)
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    static var sharedView: ToastView?

    // MARK: - Methods

    private func constructViewHierarchy(_ position: Position) {
        if position == .center {
            addSubview(imageView)
        }
        addSubview(label)
    }

    private func activateConstraints(_ position: Position) {
        if position == .center {
            activateConstraintsImageView()
        }
        activateConstraintsLabel(position)
    }
    
    static func showIn(_ viewController: UIViewController, message: String, iconName: String = "error", at position:Position = .bottom, completion: (() -> Void)? = nil) {
        var displayVC = viewController

        if let tabController = viewController as? UITabBarController {
          displayVC = tabController.selectedViewController ?? viewController
        }
        var bottomOffset: CGFloat = 0
        if let tabBarController = displayVC.tabBarController {
            bottomOffset = tabBarController.tabBar.bounds.height
        }

        if sharedView == nil {
            sharedView = ToastView()
        }
        sharedView?.imageView.removeFromSuperview()
        sharedView?.label.removeFromSuperview()
        sharedView?.constructViewHierarchy(position)
        sharedView?.activateConstraints(position)
        switch position {
        case .center:
            sharedView?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            sharedView?.layer.cornerRadius = 4
            sharedView?.label.textAlignment = .center
        case .top, .bottom:
            sharedView?.backgroundColor = UIColor(hex: "323232")
            sharedView?.layer.cornerRadius = 0
            sharedView?.layer.shadowOffset = CGSize(width: 0, height: 3)
            sharedView?.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
            sharedView?.label.textAlignment = .left
        }

        let image = UIImage(named: iconName)
        sharedView?.imageView.image = image
        sharedView?.label.text = message

        if sharedView?.superview == nil {
            switch position {
            case .center:
                let defaultSize = CGSize(width: 110, height: 110)
                let defaultLabelHeight: CGFloat = 20
                let labelHeight = message.height(withConstrainedWidth: 100, font: UIFont.pingFangTCRegular(ofSize: 14))
                let finalHeight = defaultSize.height - defaultLabelHeight + labelHeight

                let x = displayVC.view.bounds.width/2.0 - defaultSize.width/2.0
                let y = displayVC.view.bounds.height/2.0 - finalHeight/2.0
                sharedView?.frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: defaultSize.width, height: finalHeight))
            case .top:
                let width = displayVC.view.bounds.width-32
                let defaultSize = CGSize(width: width, height: 48)
                let defaultLabelHeight: CGFloat = 20
                let labelHeight = message.height(withConstrainedWidth: width, font: UIFont.pingFangTCRegular(ofSize: 14))
                let finalHeight = defaultSize.height - defaultLabelHeight + labelHeight
                sharedView?.frame = CGRect(origin: CGPoint(x: 16, y: 16), size: CGSize(width:width, height: finalHeight))
            case .bottom:
                let width = displayVC.view.bounds.width-32
                let defaultSize = CGSize(width: width, height: 48)
                let defaultLabelHeight: CGFloat = 20
                let labelHeight = message.height(withConstrainedWidth: width, font: UIFont.pingFangTCRegular(ofSize: 14))
                let finalHeight = defaultSize.height - defaultLabelHeight + labelHeight
                sharedView?.frame = CGRect(origin: CGPoint(x: 16, y: displayVC.view.bounds.height-bottomOffset-finalHeight), size: CGSize(width: width, height: finalHeight))
            }
            sharedView?.alpha = 0
            displayVC.view.addSubview(sharedView!)
            sharedView?.fadeIn()

            // this call needs to be counter balanced on fadeOut [1]
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2.5, execute: {
                sharedView?.fadeOut(completion: {
                    if let completion = completion {
                        completion()
                    }
                })
            })
        }
    }

    // MARK: Animations
    func fadeIn() {
      UIView.animate(withDuration: 0.33, animations: {
        self.alpha = 1.0
      })
    }

    @objc func fadeOut(completion: (() -> Void)? = nil) {

      // [1] Counter balance previous perfom:with:afterDelay
      NSObject.cancelPreviousPerformRequests(withTarget: self)

      UIView.animate(withDuration: 0.33, animations: {
        self.alpha = 0.0
      }, completion: { _ in
        self.removeFromSuperview()
        if let handler = completion {
            handler()
        }
      })
    }
}
// MARK: - Layouts
extension ToastView {
    private func activateConstraintsImageView() {
        let top = imageView.topAnchor.constraint(equalTo: topAnchor, constant: 12)
        let centerX = imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        let width = imageView.widthAnchor.constraint(equalToConstant: 60)
        let height = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)

        NSLayoutConstraint.activate([
            top, centerX, width, height
        ])
    }

    private func activateConstraintsLabel(_ position: Position) {
        switch position {
        case .center:
            let top = label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 7)
            let centerX = label.centerXAnchor.constraint(equalTo: centerXAnchor)
            let width = label.widthAnchor.constraint(equalToConstant: 100)

            NSLayoutConstraint.activate([
                top, centerX, width
            ])
        case .top, .bottom:
            let centerY = label.centerYAnchor.constraint(equalTo: centerYAnchor)
            let leading = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
            let trailing = label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)

            NSLayoutConstraint.activate([
                leading, centerY, trailing
            ])
        }
    }
}
