//
//  SignInService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/22.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift

protocol SignInService {
    func captcha() -> Single<CaptchaSession>
    func signIn(info: SignInInfo) -> Single<UserSession>
    func forgotPasswordMail(info: ForgotPasswordInfo) -> Completable
}
