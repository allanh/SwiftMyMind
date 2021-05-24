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
    let userSessionRepository: UserSessionRepository
    let signInValidationService: SignInValidatoinService
    let lastSignInInfoDataStore: LastSignInInfoDataStore

    let bag: DisposeBag = DisposeBag()
    var signInInfo: SignInInfo = SignInInfo()
    let userDefault: UserDefaults = UserDefaults.standard
    let keychainHelper: KeychainHelper = KeychainHelper.default
    // MARK: - Output
    let lastSignInInfo: BehaviorRelay<SignInAccountInfo> = BehaviorRelay.init(value: .empty())
    let storeIDValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let accountValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let passwordValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let captchaValueValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let isSecureTextEntry: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)

    let shouldRememberAccount: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let signInButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let reloadButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let activityIndicatorAnimating: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    let captchaActivityIndicatorAnimating: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)

    let userSession: PublishRelay<UserSession> = PublishRelay.init()
    let captchaSession: PublishRelay<CaptchaSession> = PublishRelay.init()
    let errorMessage: PublishRelay<String> = PublishRelay.init()

    let unexpectedErrorMessage: String = "未知的錯誤發生"
    private let shouldRememberAccountKey: String = "shouldRememberAccount"
    // MARK: - Methods
    init(userSessionRepository: UserSessionRepository,
         signInValidationService: SignInValidatoinService,
         lastSignInInfoDataStore: LastSignInInfoDataStore) {
        self.userSessionRepository = userSessionRepository
        self.signInValidationService = signInValidationService
        self.lastSignInInfoDataStore = lastSignInInfoDataStore

        configLastSignInStatus()
    }

    private func configLastSignInStatus() {
        lastSignInInfoDataStore.readShouldRememberLastSignAccountFlag()
            .done { flag in
                self.shouldRememberAccount.accept(flag)
            }
            .cauterize()

        lastSignInInfoDataStore.readLastSignInAccountInfo()
            .done { lastSignInInfo in
                self.lastSignInInfo.accept(lastSignInInfo)
            }
            .cauterize()
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

        userSessionRepository.signIn(info: signInInfo)
            .ensure {
                self.indicateSigningIn(false)
            }
            .done { userSession in
                self.saveSignInInfo(info: self.signInInfo)
            }
            .catch { [weak self] error in
                guard let self = self else { return }
                switch error {
                case APIError.serviceError(let message):
                    self.errorMessage.accept(message)
                default:
                    self.errorMessage.accept(self.unexpectedErrorMessage)
                }
            }
    }

    private func saveSignInInfo(info: SignInInfo) {
        guard shouldRememberAccount.value else {
            lastSignInInfoDataStore.removeLastSignInAccountInfo().cauterize()
            return
        }
        let storeID = info.storeID
        let account = info.account
        let accountInfo = SignInAccountInfo(storeID: storeID, account: account)
        lastSignInInfoDataStore.saveLastSignInAccountInfo(info: accountInfo).cauterize()
    }

    @objc
    func captcha() {
        indicateUpdatingCaptcha(true)
        userSessionRepository.captcha()
            .ensure {
                self.indicateUpdatingCaptcha(false)
            }
            .done { session in
                self.captchaSession.accept(session)
                self.signInInfo.captchaKey = session.key
            }
            .catch { error in
                switch error {
                case APIError.serviceError(let message):
                    self.errorMessage.accept(message)
                default:
                    self.errorMessage.accept(self.unexpectedErrorMessage)
                }
            }
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
        signInButtonEnabled.accept(!isProcessing)
        reloadButtonEnabled.accept(!isProcessing)
    }
}
