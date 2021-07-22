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
    let otpEnabled: Bool

    let bag: DisposeBag = DisposeBag()
    var signInInfo: SignInInfo = SignInInfo()
    let userDefault: UserDefaults = UserDefaults.standard
    let keychainHelper: KeychainHelper = KeychainHelper.default
    let repository: UDISecretRepository = UDISecretRepository(dataStore: UserDefaultSecretDataStore.init())
    // MARK: - Output
    let lastSignInInfo: BehaviorRelay<SignInAccountInfo> = BehaviorRelay.init(value: .empty())
    let storeIDValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let accountValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let passwordValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let captchaValueValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let otpValueValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let isSecureTextEntry: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)

    let shouldRememberAccount: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let signInButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let reloadButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let activityIndicatorAnimating: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    let captchaActivityIndicatorAnimating: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    let timeActivityIndicatorAnimating: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)

    let totp: PublishRelay<(String, String)> = PublishRelay.init()
    let userSession: PublishRelay<UserSession> = PublishRelay.init()
    let captchaSession: PublishRelay<CaptchaSession> = PublishRelay.init()
    let date: PublishRelay<ServerTime> = PublishRelay.init()
    let error: PublishRelay<Error> = PublishRelay.init()

    private let shouldRememberAccountKey: String = "shouldRememberAccount"
    // MARK: - Methods
    init(userSessionRepository: UserSessionRepository,
         signInValidationService: SignInValidatoinService,
         lastSignInInfoDataStore: LastSignInInfoDataStore,
         otpEnabled: Bool) {
        self.userSessionRepository = userSessionRepository
        self.signInValidationService = signInValidationService
        self.lastSignInInfoDataStore = lastSignInInfoDataStore
        self.otpEnabled = otpEnabled
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
        var valid = true
        let storeIDResult = signInValidationService.validateStoreID(signInInfo.storeID)
        storeIDValidationResult.accept(storeIDResult)

        let accountResult = signInValidationService.validateAccount(signInInfo.account)
        accountValidationResult.accept(accountResult)

        let passwordResult = signInValidationService.validatePassword(signInInfo.password)
        passwordValidationResult.accept(passwordResult)

        let captchaValueResult = signInValidationService.validateCaptchaValue(signInInfo.captchaValue ?? "")
        captchaValueValidationResult.accept(captchaValueResult)
        
        if storeIDResult == .valid,
           accountResult == .valid,
           passwordResult == .valid {
            valid = true
        } else {
            valid = false
        }
        if !otpEnabled, valid {
            valid = captchaValueResult == .valid
        }
        return valid
    }

    @objc
    func signIn() {
        
        indicateSigningIn(true)
        guard validateSignInInfo() else {
            indicateSigningIn(false)
            return
        }
        if !otpEnabled {
            userSessionRepository.signIn(info: signInInfo)
                .ensure {
                    self.indicateSigningIn(false)
                }
                .done { userSession in
                    self.saveSignInInfo(info: self.signInInfo)
                    self.userSession.accept(userSession)
                }
                .catch { [weak self] error in
                    guard let self = self else { return }
                    self.error.accept(error)
                }
        } else {
            if let secret = repository.secret(for: signInInfo.account, storeID: signInInfo.storeID) {
                signInInfo.otp = "000000"
    //          signInInfo.otp = secret.generatePin()
                userSessionRepository.signIn(info: signInInfo)
                    .ensure {
                        self.indicateSigningIn(false)
                    }
                    .done { userSession in
                        self.saveSignInInfo(info: self.signInInfo)
                        self.userSession.accept(userSession)
                    }
                    .catch { [weak self] error in
                        guard let self = self else { return }
                        self.error.accept(error)
                    }
            } else {
               self.indicateSigningIn(false)
               self.totp.accept((self.signInInfo.account, self.signInInfo.storeID))
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
                self.error.accept(error)
            }
    }
    
    func time() {
        userSessionRepository.time()
            .done { date in
                self.date.accept(date)
            }
            .catch { error in
                self.error.accept(error)
            }
    }

    private func indicateUpdatingCaptcha(_ isUpdating: Bool) {
        indicateNetworkProcessing(isUpdating)
        captchaActivityIndicatorAnimating.accept(isUpdating)
    }

    private func indicateUpdateTime(_ isUpdating: Bool) {
        indicateNetworkProcessing(isUpdating)
        timeActivityIndicatorAnimating.accept(isUpdating)
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
