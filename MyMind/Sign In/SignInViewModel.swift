//
//  SignInViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/22.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class SignInViewModel {

    let bag: DisposeBag = DisposeBag()
    let signInService: SignInService
    let signInValidationService: SignInValidatoinService
    var signInInfo: SignInInfo = SignInInfo()
    let userDefault: UserDefaults = UserDefaults.standard
    let keychainHelper: KeychainHelper = KeychainHelper()
    // MARK: - Output
    let lastSignInInfo: BehaviorRelay<SignInAccountInfo> = BehaviorRelay.init(value: .empty())
    let storeIDValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let accountValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let passwordValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let captchaValueValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)

    let shouldRememberAccount: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let signInButtonEnable: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let reloadButtonEnable: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let activityIndicatorAnimating: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    let captchaActivityIndicatorAnimating: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)

    let userSession: PublishRelay<UserSession> = PublishRelay.init()
    let captchaSession: PublishRelay<CaptchaSession> = PublishRelay.init()
    let errorMessage: PublishRelay<String> = PublishRelay.init()

    private let unexpectedErrorMessage: String = "未知的錯誤發生"
    private let shouldRememberAccountKey: String = "shouldRememberAccount"
    // MARK: - Methods
    init(signInService: SignInService,
         signInValidationService: SignInValidatoinService) {
        self.signInService = signInService
        self.signInValidationService = signInValidationService

        if let shouldRememberAccount = userDefault.value(forKey: shouldRememberAccountKey) as? Bool {
            self.shouldRememberAccount.accept(shouldRememberAccount)
        }

        if let lastSignInInfo = try? keychainHelper.readItem(key: .lastSignInAccountInfo, valueType: SignInAccountInfo.self) {
            self.lastSignInInfo.accept(lastSignInInfo)
        }
    }

    func validateSignInInfo() -> Bool {
        let storeIDResult = signInValidationService.validateStoreID(signInInfo.storeID)
        storeIDValidationResult.accept(storeIDResult)

        let accountResult = signInValidationService.validateAccount(signInInfo.account)
        accountValidationResult.accept(accountResult)

        let passwordResult = signInValidationService.validatePassword(signInInfo.password)
        passwordValidationResult.accept(passwordResult)

        let captchaValueResult = signInValidationService.validateCaptchaValue(signInInfo.captchaValue)
        captchaValueValidationResult.accept(captchaValueResult)

        if storeIDResult == .valid,
           accountResult == .valid,
           passwordResult == .valid,
           captchaValueResult == .valid {
            return true
        } else {
            return false
        }
    }

    @objc
    func signIn() {
        indicateSigningIn(true)
        guard validateSignInInfo() else {
            indicateSigningIn(false)
            return
        }
        signInService.signIn(info: signInInfo)
            .do(onSuccess: { [unowned self] _ in
                guard shouldRememberAccount.value else {
                    try? self.keychainHelper.removeItem(key: .lastSignInAccountInfo)
                    return
                }
                let storeID = self.signInInfo.storeID
                let account = self.signInInfo.account
                let accountInfo = SignInAccountInfo(storeID: storeID, account: account)
                try? self.keychainHelper.saveItem(accountInfo, for: .lastSignInAccountInfo)
            }, onDispose: { [unowned self] in
                self.indicateSigningIn(false)
            })
            .subscribe{ [unowned self] in
                switch $0 {
                case .success(let userSession):
                    self.userSession.accept(userSession)
                case .failure(let error):
                    switch error {
                    case APIError.serviceError(let message):
                        self.errorMessage.accept(message)
                    default:
                        self.errorMessage.accept(unexpectedErrorMessage)
                    }
                }
            }
            .disposed(by: bag)
    }

    @objc
    func captcha() {
        indicateUpdatingCaptcha(true)
        signInService.captcha()
            .do(onDispose: { [unowned self] in
                indicateUpdatingCaptcha(false)
            })
            .subscribe { [unowned self] in
                switch $0 {
                case .success(let session):
                    self.captchaSession.accept(session)
                    self.signInInfo.captchaKey = session.key
                case .failure(let error):
                    switch error {
                    case APIError.serviceError(let message):
                        self.errorMessage.accept(message)
                    default:
                        self.errorMessage.accept(unexpectedErrorMessage)
                    }
                }
            }
            .disposed(by: bag)
    }

    private func indicateUpdatingCaptcha(_ isUpdating: Bool) {
        indicateNetworkProcessing(isUpdating)
        captchaActivityIndicatorAnimating.accept(isUpdating)
    }

    private func indicateSigningIn(_ isSigningIn: Bool) {
        indicateNetworkProcessing(isSigningIn)
        activityIndicatorAnimating.accept(isSigningIn)
    }

    private func indicateNetworkProcessing(_ isProcessing: Bool) {
        signInButtonEnable.accept(!isProcessing)
        reloadButtonEnable.accept(!isProcessing)
    }
}
