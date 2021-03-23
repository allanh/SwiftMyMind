//
//  SignInViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/22.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    let viewModel: SignInViewModel

    var rootView: SignInRootView {
        return view as! SignInRootView
    }

    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = SignInRootView(viewModel: viewModel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.captcha()
        addTapToResignKeyboardGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      addKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      removeObservers()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootView.resetScrollViewContentInsets()
    }

    func observerViewModel() {

    }
}
// MARK: - Keyboard handle
extension SignInViewController {
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
