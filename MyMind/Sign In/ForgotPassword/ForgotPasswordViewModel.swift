//
//  ForgotPasswordViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class ForgotPasswordViewModel {
    let bag: DisposeBag = DisposeBag()
    let authService: AuthService
    let signInValidationService: SignInValidatoinService
    let otpEnabled: Bool
    var forgotPasswordInfo: ForgotPasswordInfo = .empty()
    let repository: UDISecretRepository = UDISecretRepository(dataStore: UserDefaultSecretDataStore.init())

    // MARK: - Output
    let storeIDValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let accountValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let emailValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let captchaValueValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)

    let confirmButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let reloadButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let activityIndicatorAnimating: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    let captchaActivityIndicatorAnimating: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)

    let totp: PublishRelay<(String, String)> = PublishRelay.init()
    let successMessage: PublishRelay<String> = PublishRelay.init()
    let captchaSession: PublishRelay<CaptchaSession> = PublishRelay.init()
    let errorMessage: PublishRelay<String> = PublishRelay.init()
    let date: PublishRelay<ServerTime> = PublishRelay.init()

    let unexpectedErrorMessage: String = "未知的錯誤發生"

    init(authService: AuthService,
         signInValidationService: SignInValidatoinService,
         otpEnabled: Bool) {
        self.authService = authService
        self.signInValidationService = signInValidationService
        self.otpEnabled = otpEnabled
    }

    func validateInputInfo() -> Bool {
        let storeIDResult = signInValidationService.validate(forgotPasswordInfo.storeID)
        storeIDValidationResult.accept(storeIDResult)

        let accountResult = signInValidationService.validate(forgotPasswordInfo.account)
        accountValidationResult.accept(accountResult)

        let emailResult = signInValidationService.validate(forgotPasswordInfo.email)
        emailValidationResult.accept(emailResult)
        let captchaValueResult = signInValidationService.validate(forgotPasswordInfo.captchaValue ?? "")
        captchaValueValidationResult.accept(captchaValueResult)

        var result: Bool = false
        if !otpEnabled {
            if accountResult == .valid,
               accountResult == .valid,
               captchaValueResult == .valid {
                result = true
            }
        } else {
            if accountResult == .valid,
               emailResult == .valid {
                result = true
            }
        }
        return result
    }

    @objc
    func confirmSendEmail() {
        indicateSendingEmail(true)
        guard validateInputInfo() else {
            indicateSendingEmail(false)
            return
        }
        if !otpEnabled {
            authService.forgotPasswordMail(info: forgotPasswordInfo)
                .done { self.successMessage.accept("重設密碼連結已寄出！") }
                .ensure {
                    self.indicateSendingEmail(false)
                }
                .catch { error in
                    switch error {
                    case APIError.serviceError(let message):
                        self.errorMessage.accept(message)
                    default:
                        self.errorMessage.accept(self.unexpectedErrorMessage)
                    }
                }
        } else {
            if let secret = repository.secret(for: forgotPasswordInfo.account, storeID: forgotPasswordInfo.storeID) {
                forgotPasswordInfo.otp = secret.generatePin(decode: .base32)
                authService.forgotPasswordMail(info: forgotPasswordInfo)
                    .done { self.successMessage.accept("重設密碼連結已寄出！") }
                    .ensure {
                        self.indicateSendingEmail(false)
                    }
                    .catch { error in
                        switch error {
                        case APIError.serviceError(let message):
                            self.errorMessage.accept(message)
                        default:
                            self.errorMessage.accept(self.unexpectedErrorMessage)
                        }
                    }
            } else {
                self.totp.accept((self.forgotPasswordInfo.account, self.forgotPasswordInfo.storeID))
            }
        }
    }

    @objc
    func captcha() {
        indicateUpdatingCaptcha(true)
        authService.captcha()
            .ensure { self.indicateUpdatingCaptcha(false) }
            .done { session in
                self.captchaSession.accept(session)
                self.forgotPasswordInfo.captchaKey = session.key
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
    
    func time() {
        authService.time()
            .done { date in
                self.date.accept(date)
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

    private func indicateSendingEmail(_ isSending: Bool) {
        indicateNetworkProcessing(isSending)
        activityIndicatorAnimating.accept(isSending)
    }

    private func indicateNetworkProcessing(_ isProcessing: Bool) {
        confirmButtonEnabled.accept(!isProcessing)
        reloadButtonEnabled.accept(!isProcessing)
    }
}
