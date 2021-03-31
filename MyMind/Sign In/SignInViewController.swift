//
//  SignInViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/22.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift
import NVActivityIndicatorView

class SignInViewController: NiblessViewController {

    let viewModel: SignInViewModel
    let bag: DisposeBag = DisposeBag()
    private var didLayoutRootView: Bool = false

    var rootView: SignInRootView {
        return view as! SignInRootView
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init()
    }


    override func loadView() {
        view = SignInRootView(viewModel: viewModel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.captcha()
        addTapToResignKeyboardGesture()
        observerViewModel()
        configForgotPasswordButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
//        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
//        navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if didLayoutRootView == false {
            rootView.resetScrollViewContentInsets()
            didLayoutRootView = true
        }
    }

    func configForgotPasswordButton() {
        rootView.resetPasswordButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.showForgotPasswordViewController()
            })
            .disposed(by: bag)
    }

    func observerViewModel() {
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                ToastView.showIn(self, message: $0)
            })
            .disposed(by: bag)

        viewModel.activityIndicatorAnimating
            .bind(to: self.rx.isActivityIndicatorAnimating)
            .disposed(by: bag)

        viewModel.userSession
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                ToastView.showIn(self, message: "登入成功", iconName: "success")
            })
            .disposed(by: bag)
    }

    func showForgotPasswordViewController() {
        let viewModel = ForgotPasswordViewModel(
            signInService: MyMindSignInService(),
            signInValidationService: SignInValidatoinService()
        )
        let viewController = ForgotPasswordViewController(viewModel: viewModel)
        show(viewController, sender: self)
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
