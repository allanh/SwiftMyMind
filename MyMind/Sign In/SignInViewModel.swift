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
    var signInInfo: SignInInfo = SignInInfo()
    // MARK: - Output
    let signInButtonEnable: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let reloadButtonEnable: BehaviorRelay<Bool> = BehaviorRelay.init(value: true)
    let activityIndicatorAnimating: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    let captchaActivityIndicatorAnimating: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    let userSession: PublishRelay<UserSession> = PublishRelay.init()
    let captchaSession: PublishRelay<CaptchaSession> = PublishRelay.init()
    let errorMessage: PublishRelay<String> = PublishRelay.init()

    private let unexpectedErrorMessage: String = "未知的錯誤發生"
    // MARK: - Methods
    init(signInService: SignInService) {
        self.signInService = signInService
    }

    @objc
    func signIn() {
        indicateSigningIn(true)
        signInService.signIn(info: signInInfo)
            .do(onDispose: { [unowned self] in
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
