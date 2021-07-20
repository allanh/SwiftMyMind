//
//  ForgotPasswordViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

class ForgotPasswordViewController: NiblessViewController {

    let viewModel: ForgotPasswordViewModel
    private var didLayoutRootView: Bool = false
    let bag: DisposeBag = DisposeBag()

    var rootView: ForgotPasswordRootView {
        return view as! ForgotPasswordRootView
    }

    init(viewModel: ForgotPasswordViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func loadView() {
        view = ForgotPasswordRootView(viewModel: viewModel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.captcha()
        observerViewModel()
        addTapToResignKeyboardGesture()
        addCustomBackNavigationItem()
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
        if didLayoutRootView == false {
            rootView.resetScrollViewContentInsets()
            didLayoutRootView = true
        }
    }

    func observerViewModel() {
        viewModel.activityIndicatorAnimating
            .bind(to: self.rx.isActivityIndicatorAnimating)
            .disposed(by: bag)
        
        viewModel.totp
            .observe(on: MainScheduler.instance)
            .subscribe({ [unowned self] user in
                let storyboard: UIStoryboard = UIStoryboard(name: "TOTP", bundle: nil)
                if let viewController = storyboard.instantiateViewController(withIdentifier: "SecretListViewControllerNavi") as? UINavigationController, let totpViewController = viewController.topViewController as? SecretListViewController {
                    totpViewController.requiredUser = user.element
                    totpViewController.scanViewControllerDelegate = self
                    present(viewController, animated: true, completion: nil)
                }
            })
            .disposed(by: bag)

        viewModel.successMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                ToastView.showIn(self, message: $0, iconName: "success")
            })
            .disposed(by: bag)

        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                ToastView.showIn(self, message: $0)
            })
            .disposed(by: bag)
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
extension ForgotPasswordViewController: ScanViewControllerDelegate {
    func scanViewController(_ scanViewController: ScanViewController, didReceive qrCodeValue: String) {
        if let url = URL(string: qrCodeValue),
           let secret = Secret.init(url: url) {
            updateAndSaveSecret(secret: secret)
        } else if let secret = Secret.generateSecret(with: qrCodeValue) {
            updateAndSaveSecret(secret: secret)
        }
        dismiss(animated: true) {
            self.viewModel.confirmSendEmail()
        }
    }
    private func updateAndSaveSecret(secret: Secret) {
        viewModel.repository.update(newSecrets: secret)
        try? viewModel.repository.saveSecrets()
    }
    func scanViewController(_ scanViewController: ScanViewController, validate qrCodeValue: String) -> Bool {
        if let url = URL(string: qrCodeValue),
           let secret = Secret.init(url: url) {
            return secret.user == viewModel.forgotPasswordInfo.userNameForSecret
        } else if let secret = Secret.generateSecret(with: qrCodeValue) {
            return secret.user == viewModel.forgotPasswordInfo.userNameForSecret
        }
        return false
    }
}
