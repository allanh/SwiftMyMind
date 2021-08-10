//
//  AuthService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/22.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

protocol AuthService {
    func captcha() -> Promise<CaptchaSession>
    func signIn(info: SignInInfo) -> Promise<UserSession>
    func forgotPasswordMail(info: ForgotPasswordInfo) -> Promise<Void>
    func resendOTPMail(info: ResendOTPInfo) -> Promise<Void>
    func time() -> Promise<ServerTime>
    func binding(info: BindingInfo) -> Promise<Void>
}
