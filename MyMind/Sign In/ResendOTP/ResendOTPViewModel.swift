//
//  ResendOTPViewModel.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/19.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
class ResendOTPViewModel {
    let bag: DisposeBag = DisposeBag()
    let authService: AuthService
    let signInValidationService: SignInValidatoinService
    var resendOTPInfo: ResendOTPInfo = .empty()

    // MARK: - Output
    let storeIDValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let accountValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let passwordValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let emailValidationResult: BehaviorRelay<ValidationResult> = BehaviorRelay.init(value: .valid)
    let isSecureTextEntry: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)

    let confirmButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let activityIndicatorAnimating: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)

    let successMessage: PublishRelay<String> = PublishRelay.init()
    let errorMessage: PublishRelay<String> = PublishRelay.init()
    let unexpectedErrorMessage: String = "未知的錯誤發生"

    init(authService: AuthService,
         signInValidationService: SignInValidatoinService) {
        self.authService = authService
        self.signInValidationService = signInValidationService
    }

    func validateInputInfo() -> Bool {
        let storeIDResult = signInValidationService.validate(resendOTPInfo.storeID)
        storeIDValidationResult.accept(storeIDResult)

        let accountResult = signInValidationService.validate(resendOTPInfo.account)
        accountValidationResult.accept(accountResult)

        let passwordResult = signInValidationService.validate(resendOTPInfo.password)
        passwordValidationResult.accept(passwordResult)

        let result = storeIDResult == .valid
            && accountResult == .valid
            && passwordResult == .valid

        return result
    }

    @objc
    func confirmSendEmail() {
        indicateSendingEmail(true)
        guard validateInputInfo() else {
            indicateSendingEmail(false)
            return
        }
        authService.resendOTPMail(info: resendOTPInfo)
            .done { self.successMessage.accept("新認證碼QR Code已寄出！") }
            .ensure { self.indicateSendingEmail(false) }
            .catch { error in
                switch error {
                case APIError.serviceError(let message):
                    self.errorMessage.accept(message)
                default:
                    self.errorMessage.accept(self.unexpectedErrorMessage)
                }
            }
    }

    private func indicateSendingEmail(_ isSending: Bool) {
        indicateNetworkProcessing(isSending)
        activityIndicatorAnimating.accept(isSending)
    }

    private func indicateNetworkProcessing(_ isProcessing: Bool) {
        confirmButtonEnabled.accept(!isProcessing)
    }
}
