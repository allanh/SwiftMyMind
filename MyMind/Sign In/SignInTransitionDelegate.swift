//
//  SignInTransitionDelegate.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/31.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
class SignInTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    static let shared: SignInTransitionDelegate = .init()
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SignInPresentationController(presentedViewController: presented, presenting: presenting)
    }

}
