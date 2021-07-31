//
//  SignInPresentationController.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/31.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
class SignInPresentationController: UIPresentationController {
    let blurEffectView: UIVisualEffectView!
    var swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    @objc
    func dismiss(){
        self.presentedViewController.dismiss(animated: true) {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                if !topController.isKind(of: SignInViewController.self) {
                    let navigationTitleView: UIImageView = UIImageView {
                        $0.image = UIImage(named: "udi_logo")
                    }
                    (topController as? UINavigationController)?.topViewController?.navigationItem.titleView = navigationTitleView
                }
            }
        }
    }
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.dismiss))
        swipeGestureRecognizer.direction = .down
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(swipeGestureRecognizer)
    }

    override var frameOfPresentedViewInContainerView: CGRect{
        return CGRect(origin: CGPoint(x: 25, y: 144), size: CGSize(width: self.containerView!.frame.width-50, height: self.containerView!.frame.height-158))
    }
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.layer.masksToBounds = true
        presentedView!.layer.cornerRadius = 10
    }
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        self.presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0.1
        })
    }
}
