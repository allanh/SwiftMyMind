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
    var forgotPasswordInfo: ForgotPasswordInfo = .empty()
    let repository: UDISecretRepository = UDISecretRepository(dataStore: UserDefaultSecretDataStore.init())

    // MARK: - Output
    let storeIDValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let accountValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let emailValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
//    let captchaValueValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)

    let confirmButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let reloadButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let activityIndicatorAnimating: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
//    let captchaActivityIndicatorAnimating: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)

    let totp: PublishRelay<String> = PublishRelay.init()
    let successMessage: PublishRelay<String> = PublishRelay.init()
//    let captchaSession: PublishRelay<CaptchaSession> = PublishRelay.init()
    let errorMessage: PublishRelay<String> = PublishRelay.init()

    let unexpectedErrorMessage: String = "未知的錯誤發生"

    init(authService: AuthService,
         signInValidationService: SignInValidatoinService) {
        self.authService = authService
        self.signInValidationService = signInValidationService
    }

    func validateInputInfo() -> Bool {
        let storeIDResult = signInValidationService.validateStoreID(forgotPasswordInfo.storeID)
        storeIDValidationResult.accept(storeIDResult)

        let accountResult = signInValidationService.validateAccount(forgotPasswordInfo.account)
        accountValidationResult.accept(accountResult)

        let emailResult = signInValidationService.validateEmail(forgotPasswordInfo.email)
        emailValidationResult.accept(emailResult)

//        let captchaValueResult = signInValidationService.validateCaptchaValue(forgotPasswordInfo.captchaValue)
//        captchaValueValidationResult.accept(captchaValueResult)

        let result = storeIDResult == .valid
            && accountResult == .valid
            && emailResult == .valid
//            && captchaValueResult == .valid

        return result
    }

    @objc
    func confirmSendEmail() {
        indicateSendingEmail(true)
        guard validateInputInfo() else {
            indicateSendingEmail(false)
            return
        }
        if let secret = repository.secret(for: forgotPasswordInfo.userNameForSecret) {
            forgotPasswordInfo.otp = "000000"
//            forgotPasswordInfo.otp = secret.generatePin()
            authService.forgotPasswordMail(info: forgotPasswordInfo)
                .done { self.successMessage.accept("重設密碼連結已寄出！") }
                .catch { error in
                    switch error {
                    case APIError.serviceError(let message):
                        self.errorMessage.accept(message)
                    default:
                        self.errorMessage.accept(self.unexpectedErrorMessage)
                    }
                }
        } else {
            self.totp.accept(self.forgotPasswordInfo.userNameForSecret)
        }

    }

    @objc
    func captcha() {
//        indicateUpdatingCaptcha(true)
//        authService.captcha()
//            .ensure { self.indicateUpdatingCaptcha(false) }
//            .done { session in
//                self.captchaSession.accept(session)
//                self.forgotPasswordInfo.captchaKey = session.key
//            }
//            .catch { error in
//                switch error {
//                case APIError.serviceError(let message):
//                    self.errorMessage.accept(message)
//                default:
//                    self.errorMessage.accept(self.unexpectedErrorMessage)
//                }
//            }
    }

//    private func indicateUpdatingCaptcha(_ isUpdating: Bool) {
//        indicateNetworkProcessing(isUpdating)
//        captchaActivityIndicatorAnimating.accept(isUpdating)
//    }

    private func indicateSendingEmail(_ isSending: Bool) {
        indicateNetworkProcessing(isSending)
        activityIndicatorAnimating.accept(isSending)
    }

    private func indicateNetworkProcessing(_ isProcessing: Bool) {
        confirmButtonEnabled.accept(!isProcessing)
        reloadButtonEnabled.accept(!isProcessing)
    }
}
