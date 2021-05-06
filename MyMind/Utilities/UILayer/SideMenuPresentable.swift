//
//  SideMenuPresentable.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/6.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

enum SideMenuInitialDirection {
    case left, right
}

protocol SideMenuPresentable: AnyObject {
    associatedtype SideMenuViewController: UIViewController
    var sideMenuViewController: SideMenuViewController? { get set }
    var sideMenuWidth: CGFloat { get }
    var sideMenuInitialDirection: SideMenuInitialDirection { get }
    var isSideMenuShowing: Bool { get set }
    var isSideMenuAnimating: Bool { get set }
    var backgroundMaskView: UIView? { get set }
    func toggleSideMenu()
    func initialSideMenuViewController() -> SideMenuViewController
}

extension SideMenuPresentable where Self: UIViewController {
    func toggleSideMenu() {
        guard isSideMenuAnimating == false else { return }
        if sideMenuViewController == nil {
            sideMenuViewController = initialSideMenuViewController()
        }
        isSideMenuAnimating = true
        animateSideMenu()
    }

    func animateSideMenu() {
        let targetXPoint: CGFloat
        if isSideMenuShowing {
            switch sideMenuInitialDirection {
            case .right: targetXPoint = view.frame.maxX
            case .left: targetXPoint = -view.frame.maxX
            }
            animateSideMenu(to: targetXPoint) { [weak self] in
                self?.sideMenuViewController?.view.removeFromSuperview()
                self?.sideMenuViewController = nil
            }
        } else {
            constructSideMenuViewHierarchy()
            switch sideMenuInitialDirection {
            case .right: targetXPoint = view.frame.maxX - sideMenuWidth
            case .left: targetXPoint = sideMenuWidth
            }
            animateSideMenu(to: targetXPoint, completion: nil)
        }
        isSideMenuShowing.toggle()
        animateBackgroundMaskView()
    }

    func constructSideMenuViewHierarchy() {
        guard
            let sideMenuViewController = sideMenuViewController,
            let window = UIApplication.shared.windows.first(where: \.isKeyWindow)
        else { return }
        let frame: CGRect
        switch sideMenuInitialDirection {
        case .right: frame = CGRect(origin: .init(x: view.frame.maxX, y: 0), size: window.frame.size)
        case .left: frame = CGRect(origin: .init(x: -view.frame.width, y: 0), size: window.frame.size)
        }

        sideMenuViewController.view.frame = frame
        window.addSubview(sideMenuViewController.view)
    }

    func animateSideMenu(to xPosition: CGFloat, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.sideMenuViewController?.view.frame.origin.x = xPosition
        } completion: { _ in
            self.isSideMenuAnimating = false
            completion?()
        }
    }

    func animateBackgroundMaskView() {
        if isSideMenuShowing {
            let view = UIView()
            view.backgroundColor = .black
            view.frame = self.view.bounds
            view.alpha = 0
            let tapGesture = UITapGestureRecognizer()
            tapGesture.addAction { [weak self] in
                self?.toggleSideMenu()
            }
            view.addGestureRecognizer(tapGesture)
            self.view.addSubview(view)
            backgroundMaskView = view

            UIView.animate(withDuration: 0.2) {
                view.alpha = 0.7
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.backgroundMaskView?.alpha = 0
            } completion: { _ in
                self.backgroundMaskView?.removeFromSuperview()
                self.backgroundMaskView = nil
            }
        }
    }
}
