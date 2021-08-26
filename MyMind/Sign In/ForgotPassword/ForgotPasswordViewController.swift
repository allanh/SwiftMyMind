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
        if !viewModel.otpEnabled { viewModel.captcha() }
        observerViewModel()
        addTapToResignKeyboardGesture()
        addCustomBackNavigationItem()
        title = "My Mind 買賣後台"
        navigationItem.backButtonTitle = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.otpEnabled { viewModel.time() }
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
            .subscribe({ [unowned self] info in
                let storyboard: UIStoryboard = UIStoryboard(name: "TOTP", bundle: nil)
                if let viewController = storyboard.instantiateViewController(withIdentifier: "SecretListViewControllerNavi") as? UINavigationController, let totpViewController = viewController.topViewController as? SecretListViewController {
                    totpViewController.scanViewControllerDelegate = self
                    show(totpViewController, sender: self)
                }
            })
            .disposed(by: bag)

        viewModel.successMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                ToastView.showIn(self, message: $0, iconName: "success", at: .center) {
                    navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: bag)

        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                if $0 == "OTP驗證碼錯誤" {
                    let alert = UIAlertController(title: "OTP驗證碼已失效", message: "1.請檢視手機時間與中原標準時間一致\n2.請至信箱查看「帳號綁定OTP驗證通知信」，並確認掃描的QR Code為最新版本」", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in
                    }
                    let confirmAction = UIAlertAction(title: "確定", style: .default) { action in
                        let storyboard: UIStoryboard = UIStoryboard(name: "TOTP", bundle: nil)
                        if let secretListViewController = storyboard.instantiateViewController(identifier: "SecretListViewController") as? SecretListViewController {
                            secretListViewController.scanViewControllerDelegate = self
                            show(secretListViewController, sender: self)
                        }
                   }
                    alert.addAction(cancelAction)
                    alert.addAction(confirmAction)
                    present(alert, animated: true, completion: nil)
                } else {
                    ToastView.showIn(self, message: $0)
                }
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
        viewModel.confirmSendEmail()
    }
    private func updateAndSaveSecret(secret: Secret) {
        viewModel.repository.update(newSecrets: secret)
        try? viewModel.repository.saveSecrets()
    }
    func scanViewController(_ scanViewController: ScanViewController, validate qrCodeValue: String) -> Bool {
        if let url = URL(string: qrCodeValue),
           let secret = Secret.init(url: url) {
            return secret.user == viewModel.forgotPasswordInfo.account && secret.id == viewModel.forgotPasswordInfo.storeID
        } else if let secret = Secret.generateSecret(with: qrCodeValue) {
            return secret.user == viewModel.forgotPasswordInfo.account && secret.id == viewModel.forgotPasswordInfo.storeID
        }
        return false
    }
}
