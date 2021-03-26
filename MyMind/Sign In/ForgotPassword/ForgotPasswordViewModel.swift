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
    let signInService: SignInService
    let signInValidationService: SignInValidatoinService
    var forgotPasswordInfo: ForgotPasswordInfo = .empty()

    // MARK: - Output
    let storeIDValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let accountValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let emailValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let captchaValueValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)


    let confirmButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let reloadButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let activityIndicatorAnimating: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    let captchaActivityIndicatorAnimating: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)

    let successMessage: PublishRelay<String> = PublishRelay.init()
    let captchaSession: PublishRelay<CaptchaSession> = PublishRelay.init()
    let errorMessage: PublishRelay<String> = PublishRelay.init()

    private let unexpectedErrorMessage: String = "未知的錯誤發生"

    init(signInService: SignInService,
         signInValidationService: SignInValidatoinService) {
        self.signInService = signInService
        self.signInValidationService = signInValidationService
    }

    func validateInputInfo() -> Bool {
        let storeIDResult = signInValidationService.validateStoreID(forgotPasswordInfo.storeID)
        storeIDValidationResult.accept(storeIDResult)

        let accountResult = signInValidationService.validateAccount(forgotPasswordInfo.account)
        accountValidationResult.accept(accountResult)

        let emailResult = signInValidationService.validateEmail(forgotPasswordInfo.email)
        emailValidationResult.accept(emailResult)

        let captchaValueResult = signInValidationService.validateCaptchaValue(forgotPasswordInfo.captchaValue)
        captchaValueValidationResult.accept(captchaValueResult)

        let result = storeIDResult == .valid
            && accountResult == .valid
            && emailResult == .valid
            && captchaValueResult == .valid

        return result
    }

    @objc
    func confirmSendEmail() {
        indicateSendingEmail(true)
        guard validateInputInfo() else {
            indicateSendingEmail(false)
            return
        }
        signInService.forgotPasswordMail(info: forgotPasswordInfo)
            .subscribe { [unowned self] in
                self.successMessage.accept("重設密碼連結已寄出！")
            } onError: { [unowned self] (error) in
                switch error {
                case APIError.serviceError(let message):
                    self.errorMessage.accept(message)
                default:
                    self.errorMessage.accept(unexpectedErrorMessage)
                }
            } onDisposed: { [unowned self] in
                self.indicateSendingEmail(false)
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
                    self.forgotPasswordInfo.captchaKey = session.key
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

    private func indicateSendingEmail(_ isSending: Bool) {
        indicateNetworkProcessing(isSending)
        activityIndicatorAnimating.accept(isSending)
    }

    private func indicateNetworkProcessing(_ isProcessing: Bool) {
        confirmButtonEnabled.accept(!isProcessing)
        reloadButtonEnabled.accept(!isProcessing)
    }
}
