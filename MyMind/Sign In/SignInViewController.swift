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
        if !viewModel.otpEnabled { viewModel.captcha() }
        addTapToResignKeyboardGesture()
        observerViewModel()
        configForgotPasswordButton()
        configResendOTPButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.otpEnabled { viewModel.time() }
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
    func configResendOTPButton() {
        rootView.resendOTPButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.showResendOTPViewController()
            })
            .disposed(by: bag)
    }
    private func showHomePage() {
        MyMindEmployeeAPIService.shared.authorization()
            .done { authorization in
                self.dismiss(animated: true) {
                    let scene = UIApplication.shared.connectedScenes.first
                    if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                        let rootTabBarViewController = RootTabBarController(authorization: authorization)
                        sceneDelegate.window?.rootViewController?.show(rootTabBarViewController, sender: nil)
                    }
                }
            }
            .ensure {
            }
            .catch { error in
                if let apiError = error as? APIError {
                    _ = ErrorHandler.shared.handle(apiError, controller: self)
                } else {
                    ToastView.showIn(self, message: error.localizedDescription)
                }
            }
    }

    func observerViewModel() {
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                if let apiError = $0 as? APIError {
                    switch apiError {
                    case .serviceError(let message):
                        ToastView.showIn(self, message: message)
                    default:
                        ToastView.showIn(self, message: "")
                    }
                    
                } else {
                    ToastView.showIn(self, message: $0.localizedDescription)
                }
            })
            .disposed(by: bag)

        viewModel.totp
            .observe(on: MainScheduler.instance)
            .subscribe({ [unowned self] info in
                let alert = UIAlertController(title: "您還未綁定 OTP 驗證碼", message: "點擊確定將協助轉導至「My Mind 買賣 OTP」進行 OTP 驗證設定", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in
                }
                let confirmAction = UIAlertAction(title: "確定", style: .default) { action in
                    let storyboard: UIStoryboard = UIStoryboard(name: "TOTP", bundle: nil)
                    if let viewController = storyboard.instantiateViewController(withIdentifier: "SecretListViewControllerNavi") as? UINavigationController, let totpViewController = viewController.topViewController as? SecretListViewController {
                        totpViewController.scanViewControllerDelegate = self
                        present(viewController, animated: true, completion: nil)
                    }
               }
                alert.addAction(cancelAction)
                alert.addAction(confirmAction)
                present(alert, animated: true, completion: nil)

            })
            .disposed(by: bag)

        viewModel.activityIndicatorAnimating
            .bind(to: self.rx.isActivityIndicatorAnimating)
            .disposed(by: bag)

        viewModel.userSession
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                ToastView.showIn(self, message: "登入成功", iconName: "success")
                showHomePage()
            })
            .disposed(by: bag)
    }

    func showForgotPasswordViewController() {
        var otpEnabled: Bool = false
        do {
            otpEnabled = try KeychainHelper.default.readItem(key: .otpStatus, valueType: Bool.self)
        } catch {}
        let viewModel = ForgotPasswordViewModel(
            authService: MyMindAuthService(),
            signInValidationService: SignInValidatoinService(),
            otpEnabled: otpEnabled
        )
        let viewController = ForgotPasswordViewController(viewModel: viewModel)
        show(viewController, sender: self)
    }
    func showResendOTPViewController() {
        let viewModel = ResendOTPViewModel(authService: MyMindAuthService(),
                                           signInValidationService: SignInValidatoinService()
        )
        let viewController = ResendOTPViewController(viewModel: viewModel)
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
extension SignInViewController: ScanViewControllerDelegate {
    func scanViewController(_ scanViewController: ScanViewController, didReceive qrCodeValue: String) {
        if let url = URL(string: qrCodeValue),
           let secret = Secret.init(url: url) {
            updateAndSaveSecret(secret: secret)
        } else if let secret = Secret.generateSecret(with: qrCodeValue) {
            updateAndSaveSecret(secret: secret)
        }
        dismiss(animated: true) {
            self.viewModel.signIn()
        }
    }
    private func updateAndSaveSecret(secret: Secret) {
        viewModel.repository.update(newSecrets: secret)
        try? viewModel.repository.saveSecrets()
    }
    func scanViewController(_ scanViewController: ScanViewController, validate qrCodeValue: String) -> Bool {
        if let url = URL(string: qrCodeValue),
           let secret = Secret.init(url: url) {
            return secret.user == viewModel.signInInfo.account && secret.id == viewModel.signInInfo.storeID
        } else if let secret = Secret.generateSecret(with: qrCodeValue) {
            return secret.user == viewModel.signInInfo.account && secret.id == viewModel.signInInfo.storeID
        }
        return false
    }
}
