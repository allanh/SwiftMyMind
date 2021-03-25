//
//  ForgotPasswordViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    private var didLayoutRootView: Bool = false

    var rootView: ForgotPasswordRootView {
        return view as! ForgotPasswordRootView
    }

    override func loadView() {
        view = ForgotPasswordRootView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if didLayoutRootView == false {
            rootView.resetScrollViewContentInsets()
            didLayoutRootView = true
        }
    }
}

// MARK: - Keyboard handle
extension ForgotPasswordViewController {
    func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }

    @objc func handleContentUnderKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let convertedKeyboardEndFrame = view.convert(keyboardEndFrame.cgRectValue, from: view.window)
            if notification.name == UIResponder.keyboardWillHideNotification {
                rootView.resetScrollViewContentInsets()
            } else {
                rootView.moveContent(forKeyboardFrame: convertedKeyboardEndFrame)
            }
        }
    }
}
