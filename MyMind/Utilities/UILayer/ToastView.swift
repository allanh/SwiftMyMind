//
//  ToastView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/23.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class ToastView: NiblessView {

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
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructViewHierarchy()
        activateConstraints()
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        layer.cornerRadius = 4
    }

    private func constructViewHierarchy() {
        addSubview(imageView)
        addSubview(label)
    }

    private func activateConstraints() {
        activateConstraintsImageView()
        activateConstraintsLabel()
    }
    
    static func showIn(_ viewController: UIViewController, message: String, iconName: String = "error", completion: (() -> Void)? = nil) {
        var displayVC = viewController

        if let tabController = viewController as? UITabBarController {
          displayVC = tabController.selectedViewController ?? viewController
        }

        if sharedView == nil {
            sharedView = ToastView()
        }

        let image = UIImage(named: iconName)
        sharedView?.imageView.image = image
        sharedView?.label.text = message

        if sharedView?.superview == nil {
            let defaultSize = CGSize(width: 110, height: 110)
            let defaultLabelHeight: CGFloat = 20
            let labelHeight = message.height(withConstrainedWidth: 100, font: UIFont.pingFangTCRegular(ofSize: 14))
            let finalHeight = defaultSize.height - defaultLabelHeight + labelHeight

            let x = displayVC.view.bounds.width/2.0 - defaultSize.width/2.0
            let y = displayVC.view.bounds.height/2.0 - finalHeight/2.0
            sharedView?.frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: defaultSize.width, height: finalHeight))
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

    private func activateConstraintsLabel() {
        let top = label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 7)
        let centerX = label.centerXAnchor.constraint(equalTo: centerXAnchor)
        let width = label.widthAnchor.constraint(equalToConstant: 100)

        NSLayoutConstraint.activate([
            top, centerX, width
        ])
    }
}
