//
//  SignInViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/22.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift

class SignInViewModel {

    let bag: DisposeBag = DisposeBag()
    let signInService: SignInService
    var signInInfo: SignInInfo = SignInInfo()
    // MARK: - Output
    let signInButtonEnable: BehaviorSubject<Bool> = BehaviorSubject.init(value: true)
    let reloadButtonEnable: BehaviorSubject<Bool> = BehaviorSubject.init(value: true)
    let activityIndicatorAnimating: BehaviorSubject<Bool> = BehaviorSubject.init(value: false)
    let userSession: PublishSubject<UserSession> = PublishSubject.init()
    let captchaSession: PublishSubject<CaptchaSession> = PublishSubject.init()

    // MARK: - Methods
    init(signInService: SignInService) {
        self.signInService = signInService
    }

    @objc
    func signIn() {
        indicateNetworkProcessing()
        signInService.signIn(info: signInInfo)
            .subscribe { [unowned self] userSession in
                self.userSession.onNext(userSession)
            } onFailure: { error in

            }
            .disposed(by: bag)
    }

    @objc
    func captcha() {
        indicateNetworkProcessing()
        signInService.captcha()
            .do(onDispose: { [unowned self] in
                self.reloadButtonEnable.onNext(true)
                self.signInButtonEnable.onNext(true)
            })
            .asObservable()
            .subscribe(onNext: { [unowned self] (session) in
                self.captchaSession.onNext(session)
                self.signInInfo.captchaKey = session.key
            }, onError: { (error) in
                // TODO: handle error
            })
            .disposed(by: bag)
    }

    private func indicateNetworkProcessing() {
        signInButtonEnable.onNext(false)
        reloadButtonEnable.onNext(false)
        activityIndicatorAnimating.onNext(true)
    }
}
